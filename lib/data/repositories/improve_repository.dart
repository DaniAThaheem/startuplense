import 'package:startup_lense/core/services/ai_improve_service.dart';
import 'package:startup_lense/data/repositories/idea_repository.dart';

class ImproveRepository {
  final _ideaRepo    = IdeaRepository();

  Future<Map<String, dynamic>> getFullIdea(String ideaId) async {
    final idea = await _ideaRepo.getIdeaById(ideaId);
    if (idea == null) throw 'Idea not found';
    return idea;
  }

  Future<Map<String, dynamic>> generateSuggestions({
    required String title,
    required String problem,
    required String city,
    required String businessType,
    required double budget,
    required List<String> customers,
    required Map<String, dynamic> aiResult,
  }) async {
    return AiImproveService.generateSuggestions(
      title:        title,
      problem:      problem,
      city:         city,
      businessType: businessType,
      budget:       budget,
      customers:    customers,
      aiResult:     aiResult,
    );
  }
}