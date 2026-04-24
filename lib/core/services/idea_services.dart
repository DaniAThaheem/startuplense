import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IdeaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // In IdeaService

  Future<void> deleteIdea(String ideaId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final ideaRef = _firestore.collection('ideas').doc(ideaId);
    final userRef = _firestore.collection('users').doc(user.uid);

    final batch = _firestore.batch();

    // ✅ 1. Delete the idea document
    batch.delete(ideaRef);

    // ✅ 2. Decrement totalIdeas in user stats
    batch.update(userRef, {
      "stats.totalIdeas": FieldValue.increment(-1),
    });

    await batch.commit();
  }

  // In IdeaService

// Paginated fetch — pass null for first page, lastDoc for next pages
  Future<QuerySnapshot<Map<String, dynamic>>> getUserIdeasPaginated({
    DocumentSnapshot? lastDoc,
    int limit = 10,
  }) async {
    final userId = _auth.currentUser!.uid;

    var query = _firestore
        .collection('ideas')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamps.createdAt', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    return query.get();
  }

// Aggregate stats — runs 3 lightweight Firestore queries
  Future<Map<String, dynamic>> getUserIdeaStats() async {
    final userId = _auth.currentUser!.uid;

    final snapshot = await _firestore
        .collection('ideas')
        .where('userId', isEqualTo: userId)
        .get();

    if (snapshot.docs.isEmpty) {
      return {'total': 0, 'avgScore': 0.0, 'bestScore': 0};
    }

    final scores = snapshot.docs
        .map((d) => (d.data()['score'] ?? 0) as num)
        .toList();

    final total = scores.length;
    final best = scores.reduce((a, b) => a > b ? a : b).toInt();
    final avg = scores.reduce((a, b) => a + b) / total;

    return {'total': total, 'avgScore': avg, 'bestScore': best};
  }


  Stream<QuerySnapshot<Map<String, dynamic>>> getUserIdeasRaw() {
    final userId = _auth.currentUser!.uid;

    return _firestore
        .collection('ideas')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamps.createdAt', descending: true)
        .limit(5)
        .snapshots();
  }

  Future<String> createIdea({
    required String title,
    required String problem,
    required List<String> customers,
    required String city,
    required String businessType,
    required double budget,
    required double scale,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final ideaRef = _firestore.collection('ideas').doc();
    final userRef = _firestore.collection('users').doc(user.uid);

    final batch = _firestore.batch(); // 🔥 important

    // ✅ 1. Create idea
    batch.set(ideaRef, {
      "userId": user.uid,
      "title": title,
      "problem": problem,
      "targetCustomers": customers,
      "city": city,
      "businessType": businessType,
      "budget": budget,
      "scale": scale,
      "status": "pending",
      "aiResult": {},
      "timestamps": {
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      }
    });

    // ✅ 2. Update user stats
    batch.set(userRef, {
      "stats": {
        "totalIdeas": FieldValue.increment(1),
      },
      "timestamps": {
        "lastLogin": FieldValue.serverTimestamp(),
      }
    }, SetOptions(merge: true));

    // ✅ 3. Commit both together
    await batch.commit();

    return ideaRef.id;
  }
}