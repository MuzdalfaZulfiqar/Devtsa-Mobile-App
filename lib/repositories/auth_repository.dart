// lib/repositories/auth_repository.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthRepository {
  static const _tokenKey = 'devsta_token';

  final AuthService _authService;

  AuthRepository(this._authService);

  Future<String?> loadSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<(String token, DevstaUser user)> login(String email, String password) {
    return _authService.login(email: email, password: password);
  }

  Future<(String token, DevstaUser user)> signup(
      String name, String email, String password) {
    return _authService.signup(name: name, email: email, password: password);
  }

  Future<bool> validateToken(String token) {
    return _authService.validateToken(token);
  }

  Future<DevstaUser> fetchCurrentUser(String token) {
    return _authService.getCurrentUser(token);
  }
}
