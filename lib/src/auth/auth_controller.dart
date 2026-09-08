import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_client.dart';

enum AuthStatus {
  loading,
  signedOut,
  signedIn,
}

class AuthController extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ApiClient _api = ApiClient();

  AuthStatus status = AuthStatus.loading;
  List<String> roles = [];
  String? accessToken;

  bool get isAuthenticated {
    return status == AuthStatus.signedIn;
  }

  Future<void> restoreSession() async {
    accessToken = await _storage.read(key: 'access_token');

    status = accessToken == null
        ? AuthStatus.signedOut
        : AuthStatus.signedIn;

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final payload = await _api.post(
      '/auth/login',
      {
        'email': email,
        'password': password,
      },
    );

    accessToken = payload['accessToken']?.toString();

    final responseRoles = payload['roles'];

    if (responseRoles is List) {
      roles = responseRoles.map((role) => role.toString()).toList();
    }

    if (accessToken == null) {
      throw Exception('Login failed: no access token received.');
    }

    await _storage.write(
      key: 'access_token',
      value: accessToken,
    );

    status = AuthStatus.signedIn;

    notifyListeners();
  }

Future<void> register(Map<String, dynamic> details) async {
  final payload = await _api.post(
    '/auth/register',
    details,
  );

  accessToken = payload['accessToken']?.toString();

  final responseRoles = payload['roles'];

  if (responseRoles is List) {
    roles = responseRoles.map((role) => role.toString()).toList();
  }

  if (accessToken == null) {
    throw Exception('Registration failed: no access token received.');
  }

  await _storage.write(
    key: 'access_token',
    value: accessToken,
  );

  status = AuthStatus.signedIn;

  notifyListeners();
}

  Future<void> logout() async {
    await _storage.deleteAll();

    accessToken = null;
    roles = [];

    status = AuthStatus.signedOut;

    notifyListeners();
  }
}