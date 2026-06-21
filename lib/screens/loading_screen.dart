import 'package:flutter/material.dart';

import 'result_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String code;
  final String language;

  const LoadingScreen({super.key, required this.code, required this.language});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    analyze();
  }

  Future<void> analyze() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final result =
        '''
Language: ${widget.language}

High-level feedback
- Break large logic blocks into smaller functions.
- Add clearer naming around the core data flow.
- Consider early returns to reduce nesting.

What to improve next
- Strengthen null and error handling.
- Extract repeated logic into reusable helpers.
- Add tests for the edge cases you care about most.

Snippet reviewed
${widget.code.trim()}
''';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B1020), Color(0xFF111827), Color(0xFF172554)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0x223B82F6)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66111827),
                  blurRadius: 30,
                  offset: Offset(0, 18),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 56,
                  width: 56,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
                const SizedBox(height: 18),
                const Text(
                  'AI is reviewing your code',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Checking structure, clarity, and opportunities to improve.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
