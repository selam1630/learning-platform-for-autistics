import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/models/onboarding_profile.dart';
import '../assistant/assistant_screen.dart';
import '../community/community_screen.dart';
import '../home/home_screen.dart';
import '../learning/learning_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.profile,
  });

  final OnboardingProfile profile;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _goToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        profile: widget.profile,
        onOpenLearning: () => _goToTab(1),
        onOpenAssistant: () => _goToTab(2),
        onOpenCommunity: () => _goToTab(3),
      ),
      LearningScreen(profile: widget.profile),
      const AssistantScreen(),
      const CommunityScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.white,
        selectedIndex: _currentIndex,
        indicatorColor: AppColors.greenTint,
        onDestinationSelected: _goToTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Learning',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            selectedIcon: Icon(Icons.smart_toy),
            label: 'Ask AI',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}

