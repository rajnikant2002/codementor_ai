import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import 'loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController codeController = TextEditingController();

  String selectedLanguage = 'C++';
  bool isSubmitting = false;

  final languages = const ['C++', 'Java', 'Python', 'JavaScript'];

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Future<void> analyzeCode() async {
    if (codeController.text.trim().isEmpty || isSubmitting) return;

    setState(() {
      isSubmitting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoadingScreen(
          code: codeController.text,
          language: selectedLanguage,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {
      isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundGlow(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF22C55E), Color(0xFF2563EB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CodeMentor AI',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Clean feedback for your code',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _HeroCard(
                    title: 'Review code faster',
                    subtitle:
                        'Paste a snippet, choose a language, and get actionable AI feedback in a polished flow.',
                  ),
                  const SizedBox(height: 20),
                  _SectionLabel(
                    title: 'Language',
                    hint: 'Select the primary syntax for the review',
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: languages.map((language) {
                      final isSelected = selectedLanguage == language;
                      return ChoiceChip(
                        label: Text(language),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            selectedLanguage = language;
                          });
                        },
                        backgroundColor: const Color(0x141F2937),
                        selectedColor: const Color(0xFF1D4ED8),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                        side: const BorderSide(color: Color(0x222B3553)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  _SectionLabel(
                    title: 'Code input',
                    hint: 'Drop in a function, class, or full file',
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827).withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0x223B82F6)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33111827),
                          blurRadius: 30,
                          offset: Offset(0, 18),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: codeController,
                      maxLines: 14,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        height: 1.5,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Paste your code here...',
                        hintStyle: TextStyle(color: Colors.white38),
                        contentPadding: EdgeInsets.all(18),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined, size: 18, color: Colors.white54),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your code stays in this session only.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white60,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  CustomButton(
                    label: 'Analyze Code',
                    onPressed: analyzeCode,
                    isLoading: isSubmitting,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B1020), Color(0xFF111A33), Color(0xFF0B1020)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SizedBox.expand(),
          ),
          Positioned(
            top: -60,
            right: -40,
            child: _GlowBlob(color: Color(0x332563EB), size: 180),
          ),
          Positioned(
            top: 160,
            left: -50,
            child: _GlowBlob(color: Color(0x3322C55E), size: 140),
          ),
          Positioned(
            bottom: -50,
            right: 20,
            child: _GlowBlob(color: Color(0x33A855F7), size: 160),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 90, spreadRadius: 30)],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeroCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF172554)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0x223B82F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.analytics_outlined, color: Color(0xFF93C5FD)),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.45,
              fontSize: 14.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final String hint;

  const _SectionLabel({required this.title, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          hint,
          style: const TextStyle(color: Colors.white54),
        ),
      ],
    );
  }
}
