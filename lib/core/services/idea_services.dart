import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IdeaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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