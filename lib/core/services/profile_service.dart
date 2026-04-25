import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final _firestore = FirebaseFirestore.instance;
  final _auth      = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  // ─── User profile doc ─────────────────────────────────────
  Stream<DocumentSnapshot<Map<String, dynamic>>> profileStream() {
    return _firestore.collection('users').doc(_uid).snapshots();
  }

  // ─── Stats calculated from ideas collection ───────────────
  Future<Map<String, dynamic>> fetchStats() async {
    final snapshot = await _firestore
        .collection('ideas')
        .where('userId', isEqualTo: _uid)
        .where('status', isEqualTo: 'done')
        .get();

    if (snapshot.docs.isEmpty) {
      return {
        'totalIdeas':   0,
        'bestScore':    0,
        'avgScore':     0.0,
        'lastActivity': 'No activity',
      };
    }

    final scores = snapshot.docs
        .map((d) => (d.data()['score'] as num? ?? 0))
        .toList();

    final best = scores.reduce((a, b) => a > b ? a : b).toInt();
    final avg  = scores.reduce((a, b) => a + b) / scores.length;

    // Last activity from most recent idea
    final timestamps = snapshot.docs
        .map((d) => d.data()['timestamps']?['updatedAt'])
        .whereType<Timestamp>()
        .toList();

    String lastActivity = 'N/A';
    if (timestamps.isNotEmpty) {
      timestamps.sort((a, b) => b.compareTo(a));
      lastActivity = _timeAgo(timestamps.first.toDate());
    }

    return {
      'totalIdeas':   scores.length,
      'bestScore':    best,
      'avgScore':     avg,
      'lastActivity': lastActivity,
    };
  }

  // ─── Badge logic ──────────────────────────────────────────
  String resolveBadge(int bestScore, int totalIdeas) {
    if (bestScore >= 90 && totalIdeas >= 5) return 'TOP PERFORMER';
    if (bestScore >= 75)                    return 'HIGH ACHIEVER';
    if (totalIdeas >= 3)                    return 'ACTIVE THINKER';
    return 'NEWCOMER';
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60)  return '${diff.inMinutes}m ago';
    if (diff.inHours   < 24)  return '${diff.inHours}h ago';
    if (diff.inDays    < 30)  return '${diff.inDays}d ago';
    return '${(diff.inDays / 30).floor()}mo ago';
  }
}