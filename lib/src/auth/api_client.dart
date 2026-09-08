import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  static const _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  final http.Client _http;

  ApiClient([http.Client? httpClient])
      : _http = httpClient ?? http.Client();

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    String? accessToken,
  }) async {
    final response = await _http.post(
      Uri.parse('$_baseUrl$path'),
      headers: {
        'content-type': 'application/json',
        if (accessToken != null)
          'authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw ApiException(
        _message(response),
        response.statusCode,
      );
    }

    if (response.body.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw ApiException(
      'Unexpected API response format.',
      response.statusCode,
    );
  }

    Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body, {
    String? accessToken,
  }) async {
    final response = await _http.put(
      Uri.parse('$_baseUrl$path'),
      headers: {
        'content-type': 'application/json',
        if (accessToken != null)
          'authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw ApiException(_message(response), response.statusCode);
    }

    if (response.body.isEmpty) return {};

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw ApiException(
      'Unexpected API response format.',
      response.statusCode,
    );
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    String? accessToken,
  }) async {
    final response = await _http.delete(
      Uri.parse('$_baseUrl$path'),
      headers: {
        'content-type': 'application/json',
        if (accessToken != null)
          'authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode >= 400) {
      throw ApiException(_message(response), response.statusCode);
    }

    if (response.body.isEmpty) return {};

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw ApiException(
      'Unexpected API response format.',
      response.statusCode,
    );
  }
  
  Future<Map<String, dynamic>> get(
    String path, {
    String? accessToken,
  }) async {
    final response = await _http.get(
      Uri.parse('$_baseUrl$path'),
      headers: {
        'content-type': 'application/json',
        if (accessToken != null)
          'authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode >= 400) {
      throw ApiException(
        _message(response),
        response.statusCode,
      );
    }

    if (response.body.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw ApiException(
      'Unexpected API response format.',
      response.statusCode,
    );
  }

  Future<List<Map<String, dynamic>>> getList(
    String path, {
    String? accessToken,
  }) async {
    final response = await _http.get(
      Uri.parse('$_baseUrl$path'),
      headers: {
        'content-type': 'application/json',
        if (accessToken != null)
          'authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode >= 400) {
      throw ApiException(
        _message(response),
        response.statusCode,
      );
    }

    if (response.body.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw ApiException(
        'Unexpected API response format.',
        response.statusCode,
      );
    }

    return decoded
        .map(
          (item) => Map<String, dynamic>.from(item as Map),
        )
        .toList();
  }

  String _message(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded['message']?.toString() ??
            decoded['error']?.toString() ??
            'Request failed.';
      }

      return 'Request failed.';
    } catch (_) {
      return 'Request failed.';
    }
  }

  void dispose() {
    _http.close();
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(
    this.message,
    this.statusCode,
  );

  @override
  String toString() => message;
}