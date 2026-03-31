import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/models/assistant_response.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/services/dashboard_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.service,
  });

  final DashboardService? service;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _questionController = TextEditingController(
    text: 'My child is not speaking, what should I do?',
  );

  late final DashboardService _service;
  late Future<DashboardModel> _dashboardFuture;
  AssistantResponse? _assistantResponse;
  bool _isAskingAssistant = false;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? DashboardService();
    _dashboardFuture = _service.fetchDashboard();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _dashboardFuture = _service.fetchDashboard();
    });
    await _dashboardFuture;
  }

  Future<void> _askAssistant() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      return;
    }

    setState(() {
      _isAskingAssistant = true;
    });

    try {
      final response = await _service.askAssistant(question);
      if (!mounted) {
        return;
      }

      setState(() {
        _assistantResponse = response;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isAskingAssistant = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ethiopia Autism Support'),
      ),
      body: RefreshIndicator(
        color: AppColors.softGreen,
        onRefresh: _refreshDashboard,
        child: FutureBuilder<DashboardModel>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _ErrorPanel(
                    onRetry: _refreshDashboard,
                  ),
                ],
              );
            }

            final dashboard = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                _HeroBanner(hero: dashboard.hero),
                const SizedBox(height: 20),
                const _SectionTitle(
                  title: 'Learning Modules',
                  subtitle: 'Start with simple visual lessons and routines.',
                ),
                const SizedBox(height: 12),
                ...dashboard.modules.map(_ModuleCard.new),
                const SizedBox(height: 20),
                const _SectionTitle(
                  title: 'Parent Community',
                  subtitle: 'Shared encouragement and practical daily tips.',
                ),
                const SizedBox(height: 12),
                ...dashboard.communityPosts.map(_CommunityCard.new),
                const SizedBox(height: 20),
                const _SectionTitle(
                  title: 'AI Parent Assistant',
                  subtitle: 'Expert-reviewed prompts for common caregiver questions.',
                ),
                const SizedBox(height: 12),
                _AssistantComposer(
                  controller: _questionController,
                  isLoading: _isAskingAssistant,
                  onAsk: _askAssistant,
                ),
                if (_assistantResponse != null) ...[
                  const SizedBox(height: 12),
                  _AssistantResponseCard(response: _assistantResponse!),
                ],
                const SizedBox(height: 16),
                ...dashboard.assistantGuidance.map(
                  (guidance) => _PromptSuggestionCard(
                    guidance: guidance,
                    onTap: () {
                      _questionController.text = guidance.question;
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.hero});

  final HeroContent hero;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [AppColors.softGreen, AppColors.softBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Offline-friendly support in Amharic',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            hero.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 28,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            hero.subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroPill(label: 'Lessons'),
              _HeroPill(label: 'Community'),
              _HeroPill(label: 'Assistant'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
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

class _ModuleCard extends StatelessWidget {
  const _ModuleCard(this.module);

  final LessonModule module;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.greenTint,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    module.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (module.offlineReady)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.softGreen,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Offline Ready',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              module.titleAm,
              style: const TextStyle(
                color: AppColors.softBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(module.description),
          ],
        ),
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard(this.post);

  final CommunityPost post;

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
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.warmYellow,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    post.authorName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        post.category.replaceAll('_', ' '),
                        style: const TextStyle(
                          color: AppColors.softCoral,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content),
          ],
        ),
      ),
    );
  }
}

class _AssistantComposer extends StatelessWidget {
  const _AssistantComposer({
    required this.controller,
    required this.isLoading,
    required this.onAsk,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onAsk;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.blueTint,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ask about speech, routines, or meltdowns...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.softBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: isLoading ? null : onAsk,
                child: Text(isLoading ? 'Thinking...' : 'Ask Assistant'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssistantResponseCard extends StatelessWidget {
  const _AssistantResponseCard({required this.response});

  final AssistantResponse response;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assistant Guidance',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(response.answer),
            const SizedBox(height: 10),
            Text(
              response.safetyNote,
              style: const TextStyle(
                color: AppColors.softCoral,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromptSuggestionCard extends StatelessWidget {
  const _PromptSuggestionCard({
    required this.guidance,
    required this.onTap,
  });

  final AssistantGuidance guidance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                guidance.question,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(guidance.answer),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We could not load the app data.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please make sure the backend is running on http://127.0.0.1:5000 and try again.',
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
