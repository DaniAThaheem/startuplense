import '../../core/services/gemini_service.dart';

class MarketAgent {
  static const _system = '''
You are a market research analyst specializing in South Asian especially in Pakistan's emerging markets.
Analyze the market environment for the given startup.
Return ONLY valid JSON with this exact schema:
{
  "demandLevel": "High | Medium | Low",
  "competitionLevel": "High | Medium | Low",
  "saturationLevel": "High | Medium | Low",
  "marketInsight": "2-3 sentence key market insight",
  "competitors": ["competitor1", "competitor2", "competitor3"],
  "opportunityGap": "specific underserved niche or gap",
  "tam": "estimated total addressable market e.g. PKR500M",
  "marketSentiment": "e.g. Bullish Growth (+12%)",
  "marketSignals": ["signal1", "signal2", "signal3"],
  "marketTags": ["tag1", "tag2"]
}''';

  static Future<Map<String, dynamic>> run({
    required String title,
    required String problem,
    required String city,
    required String businessType,
    required Map<String, dynamic> structureResult,
  }) async {
    final userContent = '''
Idea Title: $title
Problem: $problem
City/Region: $city
Business Type: $businessType
Structured Analysis: ${_compact(structureResult)}''';

    return GeminiService.callJson(
      systemPrompt: _system,
      userContent: userContent,
    );
  }

  static String _compact(Map<String, dynamic> m) =>
      m.entries.map((e) => '${e.key}: ${e.value}').join('\n');
}