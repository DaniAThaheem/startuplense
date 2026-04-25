import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:startup_lense/core/services/profile_service.dart';

class ProfileRepository {
  final _service = ProfileService();

  Stream<DocumentSnapshot<Map<String, dynamic>>> profileStream() =>
      _service.profileStream();

  Future<Map<String, dynamic>> fetchStats() =>
      _service.fetchStats();

  String resolveBadge(int bestScore, int totalIdeas) =>
      _service.resolveBadge(bestScore, totalIdeas);
}