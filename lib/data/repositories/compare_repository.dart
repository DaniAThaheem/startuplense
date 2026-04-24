import 'package:startup_lense/core/services/ai-compare_service.dart';
import 'package:startup_lense/data/repositories/idea_repository.dart';

class CompareRepository {
  final _aiService = AiCompareService();
  final _ideaRepo  = IdeaRepository();

  Future<Map<String, dynamic>> getFullIdea(String ideaId) async {
    final idea = await _ideaRepo.getIdeaById(ideaId);
    if (idea == null) throw 'Idea not found: $ideaId';
    return idea;
  }

  Future<Map<String, dynamic>> compareIdeas({
    required Map<String, dynamic> ideaA,
    required Map<String, dynamic> ideaB,
  }) async {
    return await _aiService.compareIdeas(ideaA: ideaA, ideaB: ideaB);
  }
}