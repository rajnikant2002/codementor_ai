import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          '''
CodeMentor AI

An AI-powered platform that helps students:

• Detect bugs
• Understand mistakes
• Learn programming concepts
• Improve code quality
• Analyze complexity

Built using Flutter and Gemini AI.
''',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}