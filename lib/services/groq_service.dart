import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/career_pilot_result.dart';
import '../models/career_tool.dart';

class GroqService {
  GroqService({String? apiKey})
    : _apiKey =
          apiKey ??
          dotenv.env['GROQ_API_KEY'] ??
          const String.fromEnvironment('GROQ_API_KEY');

  final String _apiKey;
  static const List<String> _preferredModels = [
    'llama-3.3-70b-versatile',
    'llama-3.1-70b-versatile',
    'llama-3.1-8b-instant',
    'qwen-2.5-32b',
    'mixtral-8x7b-32768',
  ];

  Future<CareerPilotResult> analyzeTool({
    required CareerTool tool,
    required Map<String, String> inputs,
  }) async {
    if (_apiKey.isEmpty) {
      return CareerPilotResult.fallback(
        tool: tool,
        message:
            'Set GROQ_API_KEY to enable live Groq responses. The app is ready, but the API key is missing.',
      );
    }

    final modelCandidates = await _resolveModelCandidates();

    final prompt = tool.buildPrompt(inputs);
    Object? lastError;

    for (final modelName in modelCandidates) {
      try {
        final response = await http.post(
          Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'model': modelName,
            'messages': [
              {'role': 'user', 'content': prompt},
            ],
            'temperature': 0.2,
            'max_tokens': 2048,
          }),
        );

        if (response.statusCode < 200 || response.statusCode >= 300) {
          final body = response.body;
          final shouldRetry =
              body.contains('model_decommissioned') ||
              body.contains('no longer supported') ||
              body.contains('invalid_request_error');

          if (shouldRetry && modelName != modelCandidates.last) {
            lastError = body;
            continue;
          }

          return CareerPilotResult.fallback(
            tool: tool,
            message:
                'Groq request failed with HTTP ${response.statusCode}. Details: $body',
          );
        }

        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = decoded['choices'] as List<dynamic>? ?? const [];
        final firstChoice = choices.isNotEmpty
            ? choices.first as Map<String, dynamic>
            : null;
        final message = firstChoice?['message'] as Map<String, dynamic>?;
        final text = (message?['content'] as String?)?.trim();
        if (text == null || text.isEmpty) {
          return CareerPilotResult.fallback(
            tool: tool,
            message: 'Groq returned an empty response. Please try again.',
          );
        }

        return CareerPilotResult.fromGemini(tool: tool, response: text);
      } catch (error) {
        lastError = error;
        if (modelName != modelCandidates.last) {
          continue;
        }
      }
    }

    return CareerPilotResult.fallback(
      tool: tool,
      message:
          'Groq request failed after trying supported models. Details: $lastError',
    );
  }

  Future<List<String>> _resolveModelCandidates() async {
    final override = const String.fromEnvironment(
      'GROQ_MODEL',
      defaultValue: '',
    );
    if (override.isNotEmpty) {
      return [override];
    }

    try {
      final response = await http.get(
        Uri.parse('https://api.groq.com/openai/v1/models'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final data = decoded['data'] as List<dynamic>? ?? const [];
        final availableIds = data
            .map((item) => (item as Map<String, dynamic>)['id'] as String?)
            .whereType<String>()
            .toSet();

        final resolved = _preferredModels
            .where(availableIds.contains)
            .toList(growable: false);

        if (resolved.isNotEmpty) {
          return resolved;
        }
      }
    } catch (_) {
      // Fall back to the preferred list below.
    }

    return _preferredModels;
  }
}
