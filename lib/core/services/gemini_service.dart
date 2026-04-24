import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _model = 'gemini-flash-latest';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  static String get _apiKey => dotenv.env['GEMINI_KEY'] ?? '';

  /// Calls Gemini with a system prompt + user content.
  /// Always returns parsed JSON map.
  /// Throws descriptive exception on failure.
  static Future<Map<String, dynamic>> callJson({
    required String systemPrompt,
    required String userContent,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/$_model:generateContent?key=$_apiKey',
    );

    final body = jsonEncode({
      'system_instruction': {
        'parts': [{'text': systemPrompt}],
      },
      'contents': [
        {
          'parts': [{'text': userContent}],
        }
      ],
      'generationConfig': {
        'responseMimeType': 'application/json',
        'temperature': 0.4,
      },
    });

    final response = await http
        .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
        .timeout(const Duration(seconds: 45));

    if (response.statusCode != 200) {
      throw Exception(
        'Gemini API error ${response.statusCode}: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final text = decoded['candidates'][0]['content']['parts'][0]['text']
    as String;

    // Strip markdown fences if present
    final clean = text
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();

    return jsonDecode(clean) as Map<String, dynamic>;
  }
}