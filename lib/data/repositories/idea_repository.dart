import '../../core/services/idea_services.dart';

class IdeaRepository {
  final IdeaService _ideaService = IdeaService();

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