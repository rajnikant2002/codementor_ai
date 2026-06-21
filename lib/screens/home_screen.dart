import 'package:flutter/material.dart';
import 'loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController codeController = TextEditingController();

  String selectedLanguage = "C++";

  Future<void> analyzeCode() async {
    if (codeController.text.trim().isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoadingScreen(
          code: codeController.text,
          language: selectedLanguage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CodeMentor AI")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              items: const [
                DropdownMenuItem(value: "C++", child: Text("C++")),
                DropdownMenuItem(value: "Java", child: Text("Java")),
                DropdownMenuItem(value: "Python", child: Text("Python")),
                DropdownMenuItem(
                  value: "JavaScript",
                  child: Text("JavaScript"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: codeController,
                expands: true,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Paste your code here...",
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: analyzeCode,
              child: const Text("Analyze Code"),
            ),
          ],
        ),
      ),
    );
  }
}
