import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/api_config.dart';
import '../models/assistant_response.dart';
import '../models/dashboard_model.dart';

class DashboardService {
  http.Client? _client;

  http.Client get client => _client ??= http.Client();

  Future<DashboardModel> fetchDashboard() async {
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/dashboard'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load dashboard');
    }

    return DashboardModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<AssistantResponse> askAssistant(String question) async {
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/assistant/ask'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'question': question}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to ask assistant');
    }

    return AssistantResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
