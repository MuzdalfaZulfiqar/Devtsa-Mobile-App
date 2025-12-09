// lib/services/auth_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/backend_config.dart';

class AuthApi {
  static final AuthApi _instance = AuthApi._();
  AuthApi._();
  factory AuthApi() => _instance;

  /// POST /api/users/signup
  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('${BackendConfig.baseUrl}/api/users/signup');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(res.body);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(data['msg'] ?? 'Signup failed');
    }
    // expected: { token, user }
    return data as Map<String, dynamic>;
  }
}
