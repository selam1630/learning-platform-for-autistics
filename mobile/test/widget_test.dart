import 'package:ethiopia_autism_support_app/data/models/assistant_response.dart';
import 'package:ethiopia_autism_support_app/data/models/dashboard_model.dart';
import 'package:ethiopia_autism_support_app/data/services/dashboard_service.dart';
import 'package:ethiopia_autism_support_app/features/home/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('shows dashboard content from the service', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(service: _FakeDashboardService()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Ethiopia Autism Support'), findsOneWidget);
    expect(find.text('Support for families, learning for children.'), findsOneWidget);
    expect(find.text('Learning Modules'), findsOneWidget);
    expect(find.text('Communication Basics'), findsOneWidget);
  });
}

class _FakeDashboardService extends DashboardService {
  @override
  Future<DashboardModel> fetchDashboard() async {
    return DashboardModel(
      hero: HeroContent(
        title: 'Support for families, learning for children.',
        subtitle: 'Offline-friendly help in Amharic and Ethiopian context.',
      ),
      modules: [
        LessonModule(
          id: '1',
          title: 'Communication Basics',
          titleAm: 'መሰረታዊ ግንኙነት',
          description: 'A sample lesson module.',
          offlineReady: true,
        ),
      ],
      communityPosts: [
        CommunityPost(
          id: '1',
          authorName: 'Selam Parent',
          category: 'communication',
          content: 'A helpful community story.',
        ),
      ],
      assistantGuidance: [
        AssistantGuidance(
          id: '1',
          question: 'How do I help my child speak?',
          answer: 'Use short words and visuals.',
        ),
      ],
    );
  }

  @override
  Future<AssistantResponse> askAssistant(String question) async {
    return AssistantResponse(
      question: question,
      answer: 'Try short repeated words.',
      safetyNote: 'This is general guidance only.',
    );
  }
}
