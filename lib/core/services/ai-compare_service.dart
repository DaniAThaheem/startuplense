import 'dart:convert';
import 'package:startup_lense/core/services/gemini_service.dart';

class AiCompareService {
  static const _systemPrompt = '''
You are an expert startup analyst and venture capitalist with 20 years of experience evaluating early-stage startups.
Your job is to perform a deep comparative analysis between two startup ideas based on their AI-generated evaluation data.
You must return ONLY a valid JSON object. No explanation, no markdown, no extra text.
''';

  Future<Map<String, dynamic>> compareIdeas({
    required Map<String, dynamic> ideaA,
    required Map<String, dynamic> ideaB,
  }) async {
    final userContent = _buildUserContent(ideaA, ideaB);

    return await GeminiService.callJson(
      systemPrompt: _systemPrompt,
      userContent:  userContent,
    );
  }

  String _buildUserContent(
      Map<String, dynamic> ideaA,
      Map<String, dynamic> ideaB,
      ) {
    final aiA = ideaA['aiResult'] as Map<String, dynamic>? ?? {};
    final aiB = ideaB['aiResult'] as Map<String, dynamic>? ?? {};

    return '''
Compare these two startup ideas and return this exact JSON structure:

{
  "viabilityInsight": "one sentence comparing overall viability of both ideas",
  "riskA": "Low|Medium|High",
  "riskB": "Low|Medium|High",
  "riskFactorsA": ["factor1", "factor2", "factor3"],
  "riskFactorsB": ["factor1", "factor2", "factor3"],
  "riskInsight": "one sentence about comparative risk between both ideas",
  "marketDemand": <number 0-100>,
  "marketCompetition": <number 0-100>,
  "marketOpportunity": <number 0-100>,
  "marketInsight": "one sentence about combined market conditions",
  "winner": "A|B",
  "winnerTitle": "exact title of the winning idea",
  "recommendation": "2-3 sentence final recommendation comparing both ideas and suggesting next steps",
  "strengthA": "single most important strength of Idea A",
  "strengthB": "single most important strength of Idea B"
}

--- IDEA A ---
Title: ${ideaA['title'] ?? 'N/A'}
Problem: ${ideaA['problem'] ?? 'N/A'}
Score: ${ideaA['score'] ?? 0}
City: ${ideaA['city'] ?? 'N/A'}
Business Type: ${ideaA['businessType'] ?? 'N/A'}

Market Data:
${jsonEncode(_map(aiA, 'market'))}

Risk Data:
${jsonEncode(_map(aiA, 'risk'))}

Evaluation:
${jsonEncode(_map(aiA, 'evaluation'))}

Strategy:
${jsonEncode(_map(aiA, 'strategy'))}

--- IDEA B ---
Title: ${ideaB['title'] ?? 'N/A'}
Problem: ${ideaB['problem'] ?? 'N/A'}
Score: ${ideaB['score'] ?? 0}
City: ${ideaB['city'] ?? 'N/A'}
Business Type: ${ideaB['businessType'] ?? 'N/A'}

Market Data:
${jsonEncode(_map(aiB, 'market'))}

Risk Data:
${jsonEncode(_map(aiB, 'risk'))}

Evaluation:
${jsonEncode(_map(aiB, 'evaluation'))}

Strategy:
${jsonEncode(_map(aiB, 'strategy'))}
''';
  }

  Map<String, dynamic> _map(Map<String, dynamic> src, String key) {
    final v = src[key];
    return v is Map ? Map<String, dynamic>.from(v) : {};
  }
}