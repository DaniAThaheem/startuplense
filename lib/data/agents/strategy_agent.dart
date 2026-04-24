import '../../core/services/gemini_service.dart';

class StrategyAgent {
  static const _system = '''
You are a startup strategy consultant expert in South Asian markets.
Generate a complete actionable go-to-market strategy.
Return ONLY valid JSON with this exact schema:
{
  "businessModel": "specific model name e.g. Freemium SaaS",
  "pricingStrategy": "detailed pricing approach",
  "marketingChannels": ["channel1", "channel2", "channel3"],
  "customerAcquisition": "primary CAC strategy",
  "launchPhases": [
    {"phase": "Phase 1", "title": "string", "description": "string", "quarter": "Q1 2025"},
    {"phase": "Phase 2", "title": "string", "description": "string", "quarter": "Q3 2025"},
    {"phase": "Phase 3", "title": "string", "description": "string", "quarter": "Q1 2026"}
  ],
  "capex": 250000,
  "burnRate": "15k/mo",
  "roiHorizon": "18 Months",
  "revenueStreams": ["stream1", "stream2"],
  "strategyTags": ["tag1", "tag2"]
}''';

  static Future<Map<String, dynamic>> run({
    required String title,
    required String city,
    required double budget,
    required Map<String, dynamic> structureResult,
    required Map<String, dynamic> marketResult,
    required Map<String, dynamic> riskResult,
  }) async {
    final userContent = '''
Idea Title: $title
City: $city
Budget: PKR ${budget.toStringAsFixed(0)}
Structure: ${_compact(structureResult)}
Market: ${_compact(marketResult)}
Risk: ${_compact(riskResult)}''';

    return GeminiService.callJson(
      systemPrompt: _system,
      userContent: userContent,
    );
  }

  static String _compact(Map<String, dynamic> m) =>
      m.entries.map((e) => '${e.key}: ${e.value}').join('\n');
}