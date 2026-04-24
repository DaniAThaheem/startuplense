import '../../core/services/gemini_service.dart';

class EvaluationAgent {
  static const _system = '''
You are the final startup evaluation agent.
Aggregate all prior analysis and produce a final verdict.
Score based on: market potential 30%, execution feasibility 25%, differentiation 25%, financial viability 20%.
Be honest but constructive.
Return ONLY valid JSON with this exact schema:
{
  "score": 78,
  "verdict": "Highly Viable | Viable | Needs Refinement | High Risk",
  "verdictLine": "one compelling sentence summarizing the verdict",
  "feasibilityExplanation": "2-3 sentences explaining the score",
  "confidence": "High | Medium | Low",
  "agreement": "High | Medium | Low",
  "improvements": ["improvement1", "improvement2", "improvement3"],
  "metricScore": 8.4,
  "coreAlignmentScore": 0.87,
  "coreAlignmentDescription": "3-4 sentences on problem-solution fit",
  "finalRecommendation": "2-3 actionable sentences for the entrepreneur"
}''';

  static Future<Map<String, dynamic>> run({
    required String title,
    required Map<String, dynamic> structureResult,
    required Map<String, dynamic> marketResult,
    required Map<String, dynamic> riskResult,
    required Map<String, dynamic> strategyResult,
  }) async {
    final userContent = '''
Idea Title: $title
Structure: ${_compact(structureResult)}
Market: ${_compact(marketResult)}
Risk: ${_compact(riskResult)}
Strategy: ${_compact(strategyResult)}''';

    return GeminiService.callJson(
      systemPrompt: _system,
      userContent: userContent,
    );
  }

  static String _compact(Map<String, dynamic> m) =>
      m.entries.map((e) => '${e.key}: ${e.value}').join('\n');
}