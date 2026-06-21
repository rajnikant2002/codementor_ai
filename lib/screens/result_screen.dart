import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/career_pilot_result.dart';
import '../models/career_tool.dart';

class ResultScreen extends StatelessWidget {
  final CareerPilotResult review;

  const ResultScreen({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(review.tool.title)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B1020), Color(0xFF111827)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1D4ED8), Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white),
                    SizedBox(height: 14),
                    Text(
                      'Your result is ready',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Review the sections below and copy the raw output if needed.',
                      style: TextStyle(color: Colors.white70, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      review.tool.subtitle,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: review.rawResponse),
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied raw response')),
                        );
                      }
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy raw'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...review.sections.map(
                (section) => _SectionCard(
                  title: section.title,
                  child: section.isCode
                      ? SelectableText(
                          section.body,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.55,
                            color: Colors.white,
                            fontFamily: 'monospace',
                          ),
                        )
                      : Text(section.body),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF111827).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0x223B82F6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 15,
                height: 1.55,
                color: Colors.white70,
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
