import 'package:flutter/material.dart';

import '../models/career_pilot_result.dart';
import '../models/career_tool.dart';
import '../services/groq_service.dart';
import 'result_screen.dart';

class LoadingScreen extends StatefulWidget {
  final CareerTool tool;
  final Map<String, String> inputs;

  const LoadingScreen({
    super.key,
    required this.tool,
    required this.inputs,
  });

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
    try {
      final review = await GroqService().analyzeTool(
        tool: widget.tool,
        inputs: widget.inputs,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(review: review)),
      );
    } catch (error) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            review: CareerPilotResult.fallback(
              tool: widget.tool,
              message: 'Groq review failed: $error',
            ),
          ),
        ),
      );
    }
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
            width: 300,
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
                const SizedBox(height: 8),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1D4ED8), Color(0xFF7C3AED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(widget.tool.icon, color: Colors.white),
                ),
                const SizedBox(height: 18),
                Text(
                  'AI is working on ${widget.tool.title}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.tool.subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                ),
                const SizedBox(height: 18),
                const SizedBox(
                  height: 48,
                  width: 48,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
                const SizedBox(height: 12),
                Text(
                  'Preparing the response and formatting it for you.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white54,
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
