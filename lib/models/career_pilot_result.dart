import 'career_tool.dart';

class ResultSection {
  final String title;
  final String body;
  final bool isCode;

  const ResultSection({
    required this.title,
    required this.body,
    this.isCode = false,
  });
}

class CareerPilotResult {
  final CareerTool tool;
  final List<ResultSection> sections;
  final String rawResponse;

  const CareerPilotResult({
    required this.tool,
    required this.sections,
    required this.rawResponse,
  });

  factory CareerPilotResult.fromGemini({
    required CareerTool tool,
    required String response,
  }) {
    final normalized = response.replaceAll('\r\n', '\n').trim();
    return CareerPilotResult(
      tool: tool,
      sections: _SectionParser.parse(normalized, tool.expectedSections),
      rawResponse: normalized,
    );
  }

  factory CareerPilotResult.fallback({
    required CareerTool tool,
    required String message,
  }) {
    return CareerPilotResult(
      tool: tool,
      sections: [ResultSection(title: 'Error', body: message)],
      rawResponse: message,
    );
  }
}

class _SectionParser {
  static List<ResultSection> parse(String text, List<String> expectedSections) {
    final lines = text.split('\n');
    final sections = <ResultSection>[];
    String? currentTitle;
    final buffer = StringBuffer();

    void flush() {
      if (currentTitle == null) {
        return;
      }

      final body = buffer.toString().trim();
      if (body.isNotEmpty) {
        final title = currentTitle;
        sections.add(
          ResultSection(
            title: title,
            body: _stripCodeFence(body),
            isCode: _looksLikeCode(title, body),
          ),
        );
      }

      buffer.clear();
    }

    for (final rawLine in lines) {
      final matched = _matchHeading(rawLine, expectedSections);
      if (matched != null) {
        flush();
        currentTitle = matched.title;
        if (matched.inlineBody != null && matched.inlineBody!.trim().isNotEmpty) {
          buffer.writeln(matched.inlineBody!.trim());
        }
        continue;
      }

      if (currentTitle != null) {
        buffer.writeln(rawLine);
      }
    }

    flush();

    if (sections.isEmpty) {
      return [ResultSection(title: 'Response', body: text)];
    }

    return sections;
  }

  static _HeadingMatch? _matchHeading(
    String line,
    List<String> expectedSections,
  ) {
    final normalizedLine = line
        .trim()
        .replaceFirst(RegExp(r'^(?:#{1,3}\s*|[-*]\s*|\d+[.)]\s*)'), '')
        .trim();

    for (final heading in expectedSections) {
      final lowerHeading = heading.toLowerCase();
      final lowerLine = normalizedLine.toLowerCase();

      if (lowerLine == lowerHeading) {
        return _HeadingMatch(title: heading);
      }

      if (lowerLine.startsWith('$lowerHeading:')) {
        return _HeadingMatch(
          title: heading,
          inlineBody: normalizedLine.substring(heading.length + 1).trim(),
        );
      }
    }

    return null;
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

  static bool _looksLikeCode(String title, String body) {
    final lowerTitle = title.toLowerCase();
    return lowerTitle.contains('code') || body.contains('```');
  }
}

class _HeadingMatch {
  final String title;
  final String? inlineBody;

  const _HeadingMatch({required this.title, this.inlineBody});
}
