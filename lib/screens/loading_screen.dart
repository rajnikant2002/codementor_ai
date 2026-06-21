import 'package:flutter/material.dart';

import 'result_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String code;
  final String language;

  const LoadingScreen({
    super.key,
    required this.code,
    required this.language,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   analyze();
  // }

  // Future<void> analyze() async {
  //   final result = await GeminiService().analyzeCode(
  //     widget.code,
  //     widget.language,
  //   );

  //   if (!mounted) return;

  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => ResultScreen(result: result),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("AI is reviewing your code..."),
          ],
        ),
      ),
    );
  }
}