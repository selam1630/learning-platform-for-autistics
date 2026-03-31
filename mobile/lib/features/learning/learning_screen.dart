import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/models/onboarding_profile.dart';
import '../../data/services/dashboard_service.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({
    super.key,
    required this.profile,
    this.service,
  });

  final OnboardingProfile profile;
  final DashboardService? service;

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late final DashboardService _service;
  late Future<DashboardModel> _dashboardFuture;

  final List<_LessonItem> _sampleLessons = const [
    _LessonItem(
      title: 'Water',
      titleAm: 'ውሃ',
      prompt: 'Where is water?',
    ),
    _LessonItem(
      title: 'Happy',
      titleAm: 'ደስተኛ',
      prompt: 'Which face is happy?',
    ),
    _LessonItem(
      title: 'Brushing Teeth',
      titleAm: 'ጥርስ መቦረሽ',
      prompt: 'What comes first in brushing?',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? DashboardService();
    _dashboardFuture = _service.fetchDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning'),
      ),
      body: FutureBuilder<DashboardModel>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Could not load learning modules.'),
            );
          }

          final dashboard = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _ProgressCard(profile: widget.profile),
              const SizedBox(height: 20),
              const _SectionHeader(
                title: 'Step 1: Select Module',
                subtitle: 'Choose a simple area and keep each session short.',
              ),
              const SizedBox(height: 12),
              ...dashboard.modules.map(_LearningModuleCard.new),
              const SizedBox(height: 20),
              const _SectionHeader(
                title: 'Step 2: Select Lesson',
                subtitle: 'Tap a lesson and practice one concept at a time.',
              ),
              const SizedBox(height: 12),
              ..._sampleLessons.map(_LessonCard.new),
              const SizedBox(height: 20),
              const _SectionHeader(
                title: 'How Lessons Work',
                subtitle: 'Image, audio, tap, feedback, and repeat.',
              ),
              const SizedBox(height: 12),
              const _LessonFlowCard(),
            ],
          );
        },
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.profile});

  final OnboardingProfile profile;

  @override
  Widget build(BuildContext context) {
    final progressText =
        profile.communicationLevel == 'non-verbal' ? 'Starter Path' : 'Growing Words Path';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.greenTint,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Parent Progress View',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text('Current plan: $progressText'),
          const SizedBox(height: 16),
          const LinearProgressIndicator(
            value: 0.35,
            minHeight: 10,
            color: AppColors.softGreen,
            backgroundColor: AppColors.white,
          ),
          const SizedBox(height: 10),
          const Text('Completed lessons: 3 of 8'),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    );
  }
}

class _LearningModuleCard extends StatelessWidget {
  const _LearningModuleCard(this.module);

  final LessonModule module;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),
        tileColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          module.title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(module.description),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard(this.lesson);

  final _LessonItem lesson;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.yellowTint,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              lesson.titleAm,
              style: const TextStyle(
                color: AppColors.softCoral,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(lesson.prompt),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 8,
              children: [
                _MiniBadge(label: 'Image'),
                _MiniBadge(label: 'Audio'),
                _MiniBadge(label: 'Tap to choose'),
                _MiniBadge(label: 'Gentle retry'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonFlowCard extends StatelessWidget {
  const _LessonFlowCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.blueTint,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lesson Flow',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 12),
          Text('1. Show image and play Amharic audio'),
          Text('2. Ask child to tap the correct choice'),
          Text('3. Give a star for success'),
          Text('4. Offer a calm retry when needed'),
          Text('5. Repeat and move to the next lesson'),
        ],
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LessonItem {
  const _LessonItem({
    required this.title,
    required this.titleAm,
    required this.prompt,
  });

  final String title;
  final String titleAm;
  final String prompt;
}
