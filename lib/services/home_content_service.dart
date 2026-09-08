import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/home_content.dart';

class HomeContentService {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  Future<HomeContent> loadHomeContent() async {
    final response = await http.get(
      Uri.parse('$apiBaseUrl/content/home'),
    );

    if (response.statusCode != 200) {
      throw Exception('Could not load ACK Hub content.');
    }

    return HomeContent.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}