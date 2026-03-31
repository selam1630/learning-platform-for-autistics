class DashboardModel {
  DashboardModel({
    required this.hero,
    required this.modules,
    required this.communityPosts,
    required this.assistantGuidance,
  });

  final HeroContent hero;
  final List<LessonModule> modules;
  final List<CommunityPost> communityPosts;
  final List<AssistantGuidance> assistantGuidance;

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      hero: HeroContent.fromJson(json['hero'] as Map<String, dynamic>),
      modules: (json['modules'] as List<dynamic>)
          .map((item) => LessonModule.fromJson(item as Map<String, dynamic>))
          .toList(),
      communityPosts: (json['communityPosts'] as List<dynamic>)
          .map((item) => CommunityPost.fromJson(item as Map<String, dynamic>))
          .toList(),
      assistantGuidance: (json['assistantGuidance'] as List<dynamic>)
          .map((item) => AssistantGuidance.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HeroContent {
  HeroContent({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  factory HeroContent.fromJson(Map<String, dynamic> json) {
    return HeroContent(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
    );
  }
}

class LessonModule {
  LessonModule({
    required this.id,
    required this.title,
    required this.titleAm,
    required this.description,
    required this.offlineReady,
  });

  final String id;
  final String title;
  final String titleAm;
  final String description;
  final bool offlineReady;

  factory LessonModule.fromJson(Map<String, dynamic> json) {
    return LessonModule(
      id: json['id'] as String,
      title: json['title'] as String,
      titleAm: json['titleAm'] as String,
      description: json['description'] as String,
      offlineReady: json['offlineReady'] as bool? ?? false,
    );
  }
}

class CommunityPost {
  CommunityPost({
    required this.id,
    required this.authorName,
    required this.category,
    required this.content,
  });

  final String id;
  final String authorName;
  final String category;
  final String content;

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] as String,
      authorName: json['authorName'] as String,
      category: json['category'] as String,
      content: json['content'] as String,
    );
  }
}

class AssistantGuidance {
  AssistantGuidance({
    required this.id,
    required this.question,
    required this.answer,
  });

  final String id;
  final String question;
  final String answer;

  factory AssistantGuidance.fromJson(Map<String, dynamic> json) {
    return AssistantGuidance(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }
}

