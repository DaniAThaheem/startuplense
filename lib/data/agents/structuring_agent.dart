import '../../core/services/gemini_service.dart';

class StructuringAgent {
  static const _system = '''
You are a startup idea structuring expert.
Convert the raw idea into a structured Business Model Skeleton.
Return ONLY valid JSON with this exact schema — no extra keys, no markdown:
{
  "problemStatement": "clear 1-2 sentence problem definition",
  "customerSegment": "specific target customer description",
  "valuePropFull": "how this uniquely solves the problem",
  "revenueModel": "primary and secondary revenue streams",
  "keyResources": ["resource1", "resource2", "resource3"],
  "businessModelType": "e.g. Freemium SaaS / Marketplace / D2C",
  "problemStrength": "Strong | Medium | Weak",
  "valuePropStrength": "Strong | Medium | Weak",
  "audienceClarity": "Clear | Moderate | Vague"
}''';

  static Future<Map<String, dynamic>> run({
    required String title,
    required String problem,
    required List<String> customers,
    required String city,
    required String businessType,
    required double budget,
  }) async {
    final userContent = '''
Idea Title: $title
Problem: $problem
Target Customers: ${customers.join(', ')}
City: $city
Business Type: $businessType
Budget: PKR ${budget.toStringAsFixed(0)}''';

    return GeminiService.callJson(
      systemPrompt: _system,
      userContent: userContent,
    );
  }
}