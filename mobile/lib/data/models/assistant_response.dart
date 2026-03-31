class AssistantResponse {
  AssistantResponse({
    required this.question,
    required this.answer,
    required this.safetyNote,
  });

  final String question;
  final String answer;
  final String safetyNote;

  factory AssistantResponse.fromJson(Map<String, dynamic> json) {
    return AssistantResponse(
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      safetyNote: json['safetyNote'] as String? ?? '',
    );
  }
}

