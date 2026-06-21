import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/career_tool.dart';
import 'tool_input_screen.dart';
import '../providers/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void openTool(CareerTool tool) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ToolInputScreen(tool: tool)));
  }

  @override
  Widget build(BuildContext context) {
    final tools = CareerTool.values;

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
                      Builder(
                        builder: (context) {
                          final logoBg = context.watch<AppState>().logoBgColor;
                          return Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: logoBg,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(7),
                              child: Image.asset(
                                'assets/ai_app_logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CareerPilot AI',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Your AI Career Assistant',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _HeroCard(
                    title: 'One app for coding and career growth',
                    subtitle:
                        'Review code, score resumes, generate projects, prepare for interviews, and map the next steps in your career.',
                  ),
                  const SizedBox(height: 18),
                  const _SectionLabel(
                    title: 'Choose a tool',
                    hint: 'Pick the AI assistant that fits your current goal',
                  ),
                  const SizedBox(height: 12),
                  ...tools.map(
                    (tool) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ToolCard(tool: tool, onTap: () => openTool(tool)),
                    ),
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
                colors: [
                  Color(0xFF0B1020),
                  Color(0xFF111A33),
                  Color(0xFF0B1020),
                ],
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
        Text(hint, style: const TextStyle(color: Colors.white54)),
      ],
    );
  }
}

class _ToolCard extends StatelessWidget {
  final CareerTool tool;
  final VoidCallback onTap;

  const _ToolCard({required this.tool, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF111827).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0x223B82F6)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33111827),
                blurRadius: 26,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1D4ED8), Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(tool.icon, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      tool.subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${tool.fields.length} inputs • ${tool.promptLabel}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}
