// lib/services/auth_service.dart
import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _api;

  AuthService(this._api);

  // Public getter for _api
  ApiClient get api => _api;


  // POST /api/users/signup
  Future<(String token, DevstaUser user)> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = await _api.postJson(
      '/api/users/signup',
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    final token = data['token']?.toString() ?? '';
    final userJson = data['user'] as Map<String, dynamic>;
    return (token, DevstaUser.fromJson(userJson));
  }

  // POST /api/users/login
  Future<(String token, DevstaUser user)> login({
    required String email,
    required String password,
  }) async {
    final data = await _api.postJson(
      '/api/users/login',
      body: {
        'email': email,
        'password': password,
      },
    );
    final token = data['token']?.toString() ?? '';
    final userJson = data['user'] as Map<String, dynamic>;
    return (token, DevstaUser.fromJson(userJson));
  }

  // GET /api/auth/validate-token
  Future<bool> validateToken(String token) async {
    try {
      final data = await _api.getJson(
        '/api/auth/validate-token',
        token: token,
      );
      return data['valid'] == true;
    } on ApiException {
      return false;
    }
  }

  // GET /api/users/me
  Future<DevstaUser> getCurrentUser(String token) async {
    final data = await _api.getJson(
      '/api/users/me',
      token: token,
    );
    // backend may wrap as { user: {...} }
    final userJson = (data['user'] ?? data) as Map<String, dynamic>;
    return DevstaUser.fromJson(userJson);
  }

   Future<Map<String, dynamic>> validateSkills(String token) async {
    final data = await _api.postJson(
      '/api/users/validate-skills', // endpoint on your backend
      token: token,
    );

    // Expect backend returns: { validated_skills: {...}, profile_score: 85 }
    return {
      'validated_skills': data['validated_skills'] ?? {},
      'profile_score': data['profile_score'] ?? 0,
    };
  }
}
