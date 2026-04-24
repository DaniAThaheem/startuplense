import '../../core/services/gemini_service.dart';

class RiskAgent {
  static const _system = '''
You are a startup risk assessment specialist.
Perform a thorough SWOT analysis and risk evaluation.
Return ONLY valid JSON with this exact schema:
{
  "marketRisk": "High | Medium | Low",
  "financialRisk": "High | Medium | Low",
  "technicalRisk": "High | Medium | Low",
  "riskInsight": "1-2 sentence overall risk summary",
  "riskTags": ["tag1", "tag2"],
  "swot": {
    "strengths": ["s1", "s2", "s3", "s4"],
    "weaknesses": ["w1", "w2", "w3", "w4"],
    "opportunities": ["o1", "o2", "o3", "o4"],
    "threats": ["t1", "t2", "t3", "t4"]
  },
  "technicalComplexity": "High | Medium | Low",
  "marketEntryDifficulty": "High | Medium | Low",
  "competitionIntensity": "High | Medium | Low",
  "financialSustainability": "High | Medium | Low"
}''';

  static Future<Map<String, dynamic>> run({
    required String title,
    required double budget,
    required Map<String, dynamic> structureResult,
    required Map<String, dynamic> marketResult,
  }) async {
    final userContent = '''
Idea Title: $title
Budget: PKR ${budget.toStringAsFixed(0)}
Structure: ${_compact(structureResult)}
Market: ${_compact(marketResult)}''';

    return GeminiService.callJson(
      systemPrompt: _system,
      userContent: userContent,
    );
  }

  static String _compact(Map<String, dynamic> m) =>
      m.entries.map((e) => '${e.key}: ${e.value}').join('\n');
}