class ReviewModel {
  final String language;
  final String bugs;
  final String explanation;
  final String timeComplexity;
  final String spaceComplexity;
  final String improvedCode;
  final String bestPractices;
  final String rawResponse;

  const ReviewModel({
    required this.language,
    required this.bugs,
    required this.explanation,
    required this.timeComplexity,
    required this.spaceComplexity,
    required this.improvedCode,
    required this.bestPractices,
    required this.rawResponse,
  });

  factory ReviewModel.fromGemini({
    required String language,
    required String response,
  }) {
    final normalized = response.replaceAll('\r\n', '\n').trim();
    final sections = _SectionParser.extract(normalized);

    return ReviewModel(
      language: language,
      bugs: sections['Bugs'] ?? 'Gemini did not return a Bugs section.',
      explanation:
          sections['Explanation'] ??
          'Gemini did not return an Explanation section.',
      timeComplexity:
          sections['Time Complexity'] ??
          'Gemini did not return Time Complexity.',
      spaceComplexity:
          sections['Space Complexity'] ??
          'Gemini did not return Space Complexity.',
      improvedCode:
          sections['Improved Code'] ??
          'Gemini did not return an Improved Code section.',
      bestPractices:
          sections['Best Practices'] ??
          'Gemini did not return a Best Practices section.',
      rawResponse: normalized,
    );
  }

  factory ReviewModel.fallback({
    required String language,
    required String message,
  }) {
    return ReviewModel(
      language: language,
      bugs: message,
      explanation: message,
      timeComplexity: message,
      spaceComplexity: message,
      improvedCode: message,
      bestPractices: message,
      rawResponse: message,
    );
  }
}

class _SectionParser {
  static const List<String> headers = [
    'Bugs',
    'Explanation',
    'Time Complexity',
    'Space Complexity',
    'Improved Code',
    'Best Practices',
  ];

  static Map<String, String> extract(String text) {
    final lines = text.split('\n');
    final buffers = <String, List<String>>{};
    String? currentHeader;

    for (final rawLine in lines) {
      final line = rawLine.trim();
      final matchedHeader = _matchHeader(line);
      if (matchedHeader != null) {
        currentHeader = matchedHeader;
        buffers.putIfAbsent(matchedHeader, () => <String>[]);
        continue;
      }

      if (currentHeader != null) {
        buffers.putIfAbsent(currentHeader, () => <String>[]).add(rawLine);
      }
    }

    final sections = <String, String>{};
    for (final entry in buffers.entries) {
      final cleaned = entry.value.join('\n').trim();
      sections[entry.key] = entry.key == 'Improved Code'
          ? _stripCodeFence(cleaned)
          : cleaned;
    }

    return sections;
  }

  static String? _matchHeader(String line) {
    final normalized = line
        .replaceFirst(RegExp(r'^\d+[.)]\s*'), '')
        .replaceFirst(RegExp(r':\s*$'), '')
        .trim()
        .toLowerCase();

    for (final header in headers) {
      if (normalized == header.toLowerCase()) {
        return header;
      }
    }

    return normalized == 'beginner-friendly explanation' ? 'Explanation' : null;
  }

  static String _stripCodeFence(String text) {
    final trimmed = text.trim();
    final fenceMatch = RegExp(
      r'^```(?:[a-zA-Z0-9_+-]+)?\s*([\s\S]*?)\s*```$',
    ).firstMatch(trimmed);
    if (fenceMatch != null) {
      return fenceMatch.group(1)!.trim();
    }

    return trimmed;
  }
}
