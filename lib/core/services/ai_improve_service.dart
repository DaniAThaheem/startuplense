import 'package:startup_lense/core/services/gemini_service.dart';

class AiImproveService {
  static const _system = '''
You are an expert startup coach and idea refinement specialist.
Analyze the given startup idea and generate specific improvement suggestions for 4 areas.
Return ONLY valid JSON with this exact schema — no markdown, no extra text:
{
  "title": {
    "suggestion": "improved version of the idea title",
    "reason": "one sentence explaining why this title is better"
  },
  "problem": {
    "suggestion": "improved and clearer problem statement",
    "reason": "one sentence explaining what was weak and how this fixes it"
  },
  "market": {
    "suggestion": "refined and specific target market/audience description",
    "reason": "one sentence on why this audience definition is stronger"
  },
  "strategy": {
    "suggestion": "improved business strategy or go-to-market approach",
    "reason": "one sentence on why this strategy increases feasibility"
  }
}''';

  static Future<Map<String, dynamic>> generateSuggestions({
    required String title,
    required String problem,
    required String city,
    required String businessType,
    required double budget,
    required List<String> customers,
    required Map<String, dynamic> aiResult,
  }) async {
    final userContent = '''
Idea Title: $title
Problem: $problem
City: $city
Business Type: $businessType
Budget: PKR ${budget.toStringAsFixed(0)}
Target Customers: ${customers.join(', ')}

Current AI Evaluation Score: ${aiResult['evaluation']?['score'] ?? 'N/A'}
Current Verdict: ${aiResult['evaluation']?['verdict'] ?? 'N/A'}
Current Weaknesses: ${aiResult['risk']?['swot']?['weaknesses'] ?? []}
Current Improvements Needed: ${aiResult['evaluation']?['improvements'] ?? []}
Problem Strength: ${aiResult['structuring']?['problemStrength'] ?? 'N/A'}
Value Prop Strength: ${aiResult['structuring']?['valuePropStrength'] ?? 'N/A'}
Market Insight: ${aiResult['market']?['marketInsight'] ?? 'N/A'}
Risk Insight: ${aiResult['risk']?['riskInsight'] ?? 'N/A'}

Based on the above weaknesses and AI feedback, suggest specific improvements.
''';

    return GeminiService.callJson(
      systemPrompt: _system,
      userContent:  userContent,
    );
  }
}