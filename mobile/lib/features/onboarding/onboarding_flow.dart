import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/models/onboarding_profile.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({
    super.key,
    required this.onComplete,
  });

  final ValueChanged<OnboardingProfile> onComplete;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _stepIndex = 0;
  String _languageCode = 'am';
  String _childAge = '3-5';
  String _communicationLevel = 'non-verbal';

  void _nextStep() {
    if (_stepIndex < 2) {
      setState(() {
        _stepIndex += 1;
      });
      return;
    }

    widget.onComplete(
      OnboardingProfile(
        languageCode: _languageCode,
        childAge: _childAge,
        communicationLevel: _communicationLevel,
      ),
    );
  }

  void _previousStep() {
    if (_stepIndex == 0) {
      return;
    }

    setState(() {
      _stepIndex -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      height: 8,
                      margin: EdgeInsets.only(right: index == 2 ? 0 : 8),
                      decoration: BoxDecoration(
                        color: index <= _stepIndex
                            ? AppColors.softGreen
                            : AppColors.lightGray,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: IndexedStack(
                  index: _stepIndex,
                  children: [
                    _WelcomeStep(),
                    _LanguageStep(
                      selectedLanguage: _languageCode,
                      onChanged: (value) {
                        setState(() {
                          _languageCode = value;
                        });
                      },
                    ),
                    _ParentSetupStep(
                      childAge: _childAge,
                      communicationLevel: _communicationLevel,
                      onAgeChanged: (value) {
                        setState(() {
                          _childAge = value;
                        });
                      },
                      onCommunicationChanged: (value) {
                        setState(() {
                          _communicationLevel = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (_stepIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: const Text('Back'),
                      ),
                    ),
                  if (_stepIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.softGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _nextStep,
                      child: Text(_stepIndex == 2 ? 'Start App' : 'Continue'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: AppColors.greenTint,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                '🌿',
                style: TextStyle(fontSize: 34),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Helping your child learn and grow',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 30,
                  ),
            ),
            const SizedBox(height: 14),
            const Text(
              'A calm and simple app for learning, support, and daily progress.',
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 28),
            const _InfoCard(
              color: AppColors.blueTint,
              title: 'Visual learning',
              subtitle: 'Simple child-friendly lessons with repetition and routine.',
            ),
            const SizedBox(height: 14),
            const _InfoCard(
              color: AppColors.yellowTint,
              title: 'Parent support',
              subtitle: 'Ask the assistant, read community tips, and track progress.',
            ),
          ],
        ),
      ],
    );
  }
}

class _LanguageStep extends StatelessWidget {
  const _LanguageStep({
    required this.selectedLanguage,
    required this.onChanged,
  });

  final String selectedLanguage;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your language',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 28,
              ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Choose the app language. Amharic is the default, and English is also available.',
        ),
        const SizedBox(height: 24),
        _SelectionCard(
          title: 'Amharic',
          subtitle: 'Default language for lessons and parent support',
          selected: selectedLanguage == 'am',
          onTap: () => onChanged('am'),
        ),
        const SizedBox(height: 12),
        _SelectionCard(
          title: 'English',
          subtitle: 'Use English for app guidance and lesson labels',
          selected: selectedLanguage == 'en',
          onTap: () => onChanged('en'),
        ),
      ],
    );
  }
}

class _ParentSetupStep extends StatelessWidget {
  const _ParentSetupStep({
    required this.childAge,
    required this.communicationLevel,
    required this.onAgeChanged,
    required this.onCommunicationChanged,
  });

  final String childAge;
  final String communicationLevel;
  final ValueChanged<String> onAgeChanged;
  final ValueChanged<String> onCommunicationChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          'Set up your child profile',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 28,
              ),
        ),
        const SizedBox(height: 12),
        const Text(
          'This helps the app personalize lessons and parent guidance.',
        ),
        const SizedBox(height: 24),
        const Text(
          'Child age',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _ChoiceChipButton(
              label: '2-3',
              selected: childAge == '2-3',
              onTap: () => onAgeChanged('2-3'),
            ),
            _ChoiceChipButton(
              label: '3-5',
              selected: childAge == '3-5',
              onTap: () => onAgeChanged('3-5'),
            ),
            _ChoiceChipButton(
              label: '6-8',
              selected: childAge == '6-8',
              onTap: () => onAgeChanged('6-8'),
            ),
            _ChoiceChipButton(
              label: '9+',
              selected: childAge == '9+',
              onTap: () => onAgeChanged('9+'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Communication level',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        _SelectionCard(
          title: 'Non-verbal',
          subtitle: 'Focus on visuals, gestures, and first communication steps',
          selected: communicationLevel == 'non-verbal',
          onTap: () => onCommunicationChanged('non-verbal'),
        ),
        const SizedBox(height: 12),
        _SelectionCard(
          title: 'Some words',
          subtitle: 'Focus on expanding vocabulary and simple requests',
          selected: communicationLevel == 'some-words',
          onTap: () => onCommunicationChanged('some-words'),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
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
          const SizedBox(height: 8),
          Text(subtitle),
        ],
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? AppColors.greenTint : AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.softGreen : AppColors.lightGray,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceChipButton extends StatelessWidget {
  const _ChoiceChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.softBlue : AppColors.lightGray,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
