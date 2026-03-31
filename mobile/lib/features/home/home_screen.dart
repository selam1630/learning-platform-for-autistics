import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/models/onboarding_profile.dart';
import '../../data/services/dashboard_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.service,
    required this.profile,
    required this.onOpenLearning,
    required this.onOpenAssistant,
    required this.onOpenCommunity,
  });

  final DashboardService? service;
  final OnboardingProfile profile;
  final VoidCallback onOpenLearning;
  final VoidCallback onOpenAssistant;
  final VoidCallback onOpenCommunity;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final DashboardService _service;
  late Future<DashboardModel> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? DashboardService();
    _dashboardFuture = _service.fetchDashboard();
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _dashboardFuture = _service.fetchDashboard();
    });
    await _dashboardFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
                  _ErrorPanel(onRetry: _refreshDashboard),
                ],
              );
            }

            final dashboard = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                _HeroBanner(profile: widget.profile),
                const SizedBox(height: 20),
                const _SectionTitle(
                  title: 'Main Dashboard',
                  subtitle: 'Choose one simple path and keep the experience predictable.',
                ),
                const SizedBox(height: 12),
                _MainActionCard(
                  color: AppColors.greenTint,
                  icon: Icons.school_outlined,
                  title: 'Learning',
                  subtitle: 'Start child lessons in communication, emotions, and daily skills.',
                  onTap: widget.onOpenLearning,
                ),
                const SizedBox(height: 12),
                _MainActionCard(
                  color: AppColors.blueTint,
                  icon: Icons.smart_toy_outlined,
                  title: 'Ask AI',
                  subtitle: 'Get short step-by-step support for speech, routines, and meltdowns.',
                  onTap: widget.onOpenAssistant,
                ),
                const SizedBox(height: 12),
                _MainActionCard(
                  color: AppColors.yellowTint,
                  icon: Icons.people_outline,
                  title: 'Community',
                  subtitle: 'Read practical tips and shared experiences from parents.',
                  onTap: widget.onOpenCommunity,
                ),
                const SizedBox(height: 24),
                const _SectionTitle(
                  title: 'Today\'s Learning',
                  subtitle: 'Quick modules recommended from your current starter plan.',
                ),
                const SizedBox(height: 12),
                ...dashboard.modules.take(3).map(_ModulePreviewCard.new),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.profile});

  final OnboardingProfile profile;

  String get languageLabel => profile.languageCode == 'am' ? 'Amharic' : 'English';

  String get communicationLabel =>
      profile.communicationLevel == 'non-verbal' ? 'Non-verbal' : 'Some words';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.softGreen, AppColors.softBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calm, safe, and encouraging learning',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Use a simple daily rhythm: learning, support, and community.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ProfilePill(label: 'Language: $languageLabel'),
              _ProfilePill(label: 'Age: ${profile.childAge}'),
              _ProfilePill(label: communicationLabel),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfilePill extends StatelessWidget {
  const _ProfilePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
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

class _MainActionCard extends StatelessWidget {
  const _MainActionCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModulePreviewCard extends StatelessWidget {
  const _ModulePreviewCard(this.module);

  final LessonModule module;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.lightGray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              module.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
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
              'We could not load the home screen data.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Please make sure the backend is running and try again.'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.softGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
