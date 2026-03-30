import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'features/home/home_screen.dart';

class AutismSupportApp extends StatelessWidget {
  const AutismSupportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethiopia Autism Support',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const HomeScreen(),
    );
  }
}

