import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/models/assistant_response.dart';
import '../../data/services/dashboard_service.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({
    super.key,
    this.service,
  });

  final DashboardService? service;

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _controller = TextEditingController(
    text: 'My child is not speaking',
  );

  late final DashboardService _service;
  AssistantResponse? _response;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? DashboardService();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final question = _controller.text.trim();
    if (question.isEmpty) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final response = await _service.askAssistant(question);
      if (!mounted) {
        return;
      }

      setState(() {
        _response = response;
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask AI'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.blueTint,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Simple parent help',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Ask in a short sentence and get a clear step-by-step answer.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'How to stop tantrums?',
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.softBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            onPressed: _loading ? null : _submit,
            child: Text(_loading ? 'Thinking...' : 'Ask Assistant'),
          ),
          const SizedBox(height: 20),
          if (_response != null) ...[
            _AssistantAnswerCard(response: _response!),
            const SizedBox(height: 20),
          ],
          const _SuggestedActionsCard(),
        ],
      ),
    );
  }
}

class _AssistantAnswerCard extends StatelessWidget {
  const _AssistantAnswerCard({required this.response});

  final AssistantResponse response;

  @override
  Widget build(BuildContext context) {
    final steps = _buildSteps(response.answer);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Response',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < steps.length; index++) ...[
            _StepRow(
              stepNumber: index + 1,
              text: steps[index],
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 6),
          Text(
            response.safetyNote,
            style: const TextStyle(
              color: AppColors.softCoral,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  List<String> _buildSteps(String answer) {
    final parts = answer
        .split('.')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    return parts.take(3).toList();
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.stepNumber,
    required this.text,
  });

  final int stepNumber;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: AppColors.softGreen,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$stepNumber',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _SuggestedActionsCard extends StatelessWidget {
  const _SuggestedActionsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.yellowTint,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggested Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 12),
          Text('Try this lesson: Communication Basics'),
          Text('Practice at home: Use one short phrase many times'),
          Text('Keep routines simple and repeatable'),
        ],
      ),
    );
  }
}
