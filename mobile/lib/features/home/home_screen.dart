import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      (
        title: 'Child Learning',
        subtitle: 'Visual lessons for communication, emotions, and routines.',
        color: const Color(0xFFE7F6F1),
      ),
      (
        title: 'Parent Community',
        subtitle: 'A safe place to share experiences, advice, and support.',
        color: const Color(0xFFFFF1D8),
      ),
      (
        title: 'AI Parent Assistant',
        subtitle: 'Step-by-step guidance built from expert-reviewed answers.',
        color: const Color(0xFFDDEBFF),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ethiopia Autism Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1D6F5F), Color(0xFF3A9D82)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Support for families, learning for children.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Offline-friendly tools in Amharic and Ethiopian context.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (final section in sections) ...[
            _SectionCard(
              title: section.title,
              subtitle: section.subtitle,
              color: section.color,
            ),
            const SizedBox(height: 16),
          ],
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MVP Goals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('1. Communication lessons'),
                  Text('2. Emotion recognition activities'),
                  Text('3. Daily routine guidance'),
                  Text('4. Parent discussion board'),
                  Text('5. Expert-backed assistant answers'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
