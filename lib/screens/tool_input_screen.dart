import 'package:flutter/material.dart';

import '../models/career_tool.dart';
import '../widgets/custom_button.dart';
import 'loading_screen.dart';

class ToolInputScreen extends StatefulWidget {
  final CareerTool tool;

  const ToolInputScreen({super.key, required this.tool});

  @override
  State<ToolInputScreen> createState() => _ToolInputScreenState();
}

class _ToolInputScreenState extends State<ToolInputScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _selectedChoices = {};
  bool isSubmitting = false;

  CareerTool get tool => widget.tool;

  @override
  void initState() {
    super.initState();
    for (final field in tool.fields) {
      if (field.type == ToolFieldType.choice) {
        _selectedChoices[field.key] = field.options.first;
      } else {
        _controllers[field.key] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> submit() async {
    if (isSubmitting) return;

    final inputs = <String, String>{};
    for (final field in tool.fields) {
      final value = field.type == ToolFieldType.choice
          ? _selectedChoices[field.key] ?? ''
          : _controllers[field.key]?.text.trim() ?? '';
      if (value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill ${field.label.toLowerCase()}')),
        );
        return;
      }
      inputs[field.key] = value;
    }

    setState(() {
      isSubmitting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LoadingScreen(tool: tool, inputs: inputs),
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
      appBar: AppBar(title: Text(tool.title)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B1020), Color(0xFF111827), Color(0xFF172554)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroCard(tool: tool),
                const SizedBox(height: 18),
                ...tool.fields.map(_buildField),
                const SizedBox(height: 18),
                CustomButton(
                  label: tool.promptLabel,
                  onPressed: submit,
                  isLoading: isSubmitting,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(ToolField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            field.hint,
            style: const TextStyle(color: Colors.white54, height: 1.35),
          ),
          const SizedBox(height: 10),
          if (field.type == ToolFieldType.choice)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: field.options.map((option) {
                final selected = _selectedChoices[field.key] == option;
                return ChoiceChip(
                  label: Text(option),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _selectedChoices[field.key] = option;
                    });
                  },
                  backgroundColor: const Color(0x141F2937),
                  selectedColor: const Color(0xFF1D4ED8),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                  side: const BorderSide(color: Color(0x222B3553)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }).toList(),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF111827).withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0x223B82F6)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33111827),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: TextField(
                controller: _controllers[field.key],
                maxLines: field.maxLines,
                keyboardType: field.type == ToolFieldType.multiline
                    ? TextInputType.multiline
                    : TextInputType.text,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  height: 1.5,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: field.hint,
                  hintStyle: const TextStyle(color: Colors.white38),
                  contentPadding: const EdgeInsets.all(18),
                  border: InputBorder.none,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final CareerTool tool;

  const _HeroCard({required this.tool});

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tool.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tool.subtitle,
                  style: const TextStyle(color: Colors.white70, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
