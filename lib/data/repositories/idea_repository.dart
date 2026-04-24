import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/services/idea_services.dart';

class IdeaRepository {
  final IdeaService _ideaService = IdeaService();

  // In IdeaRepository

  Future<void> deleteIdea(String ideaId) async {
    try {
      await _ideaService.deleteIdea(ideaId);
    } catch (e) {
      throw "Failed to delete idea";
    }
  }

  // In IdeaRepository

  Future<List<Map<String, dynamic>>> getUserIdeasPaginated({
    DocumentSnapshot? lastDoc,
    int limit = 10,
  }) async {
    final snapshot = await _ideaService.getUserIdeasPaginated(
      lastDoc: lastDoc,
      limit: limit,
    );

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        "id": doc.id,
        "snapshot": doc,           // 🔑 keep for pagination cursor
        "title": data["title"] ?? "",
        "description": data["problem"] ?? "",
        "category": data["businessType"] ?? "GENERAL",
        "score": (data["score"] ?? 0) as num,
        "status": data["status"] == "done" ? "Analyzed" : "Processing",
        "date": _formatDate(data["timestamps"]?["createdAt"]),
        "tag": _resolveTag((data["score"] ?? 0) as num),
        "city": data["city"] ?? "",
        "createdAt": data["timestamps"]?["createdAt"],
      };
    }).toList();
  }

  Future<Map<String, dynamic>> getUserIdeaStats() {
    return _ideaService.getUserIdeaStats();
  }

  String _formatDate(dynamic ts) {
    if (ts == null) return "";
    try {
      final date = ts.toDate() as DateTime;
      final months = [
        '', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
        'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
      ];
      return "${months[date.month]} ${date.day}, ${date.year}";
    } catch (_) {
      return "";
    }
  }

  String _resolveTag(num score) {
    if (score >= 80) return "High Potential";
    if (score >= 60) return "";
    return "Low Feasibility";
  }


  Stream<List<Map<String, dynamic>>> getUserIdeas() {
    return _ideaService.getUserIdeasRaw().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return {
          "id": doc.id,
          "title": data["title"] ?? "",
          "score": data["score"],

          // 👉 Business logic lives HERE
          "status": data["status"] == "done"
              ? "Analyzed"
              : "Processing",

          "city": data["city"] ?? "",
          "createdAt": data["timestamps"]?["createdAt"],
        };
      }).toList();
    });
  }

  Future<String> submitIdea({
    required String title,
    required String problem,
    required List<String> customers,
    required String city,
    required String businessType,
    required double budget,
    required double scale,
  }) async {
    try {
      return await _ideaService.createIdea(
        title: title,
        problem: problem,
        customers: customers,
        city: city,
        businessType: businessType,
        budget: budget,
        scale: scale,
      );
    } catch (e) {
      throw "Failed to submit idea";
    }
  }
}