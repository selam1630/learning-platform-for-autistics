import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'data/models/onboarding_profile.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'features/shell/app_shell.dart';

class AutismSupportApp extends StatefulWidget {
  const AutismSupportApp({super.key});

  @override
  State<AutismSupportApp> createState() => _AutismSupportAppState();
}

class _AutismSupportAppState extends State<AutismSupportApp> {
  OnboardingProfile? _profile;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethiopia Autism Support',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: _profile == null
          ? OnboardingFlow(
              onComplete: (profile) {
                setState(() {
                  _profile = profile;
                });
              },
            )
          : AppShell(
              profile: _profile!,
            ),
    );
  }
}
