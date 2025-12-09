// // lib/services/auth_api.dart
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../state/app_state.dart';
// import '../models/user_profile.dart';

// class AuthApi {
//   // 🔹 CHANGE THIS to your machine IP / base URL where Node is running
//   // Example if your Node runs on http://localhost:5000 on your laptop:
//   // - Android emulator:  http://10.0.2.2:5000
//   // - Physical device:   http://YOUR_PC_LOCAL_IP:5000
//   static const String _baseUrl = 'https://devsta-backend.onrender.com';
//   static const String _loginPath = '/api/auth/login';

//   Future<bool> login({
//     required BuildContext context,
//     required String emailOrUsername,
//     required String password,
//   }) async {
//     final uri = Uri.parse('$_baseUrl$_loginPath');

//     try {
//       final res = await http.post(
//         uri,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'emailOrUsername': emailOrUsername,
//           'password': password,
//         }),
//       );

//       // ---- CASE 4: success 200 ----
//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body) as Map<String, dynamic>;
//         final token = data['token'] as String;
//         final userJson = data['user'] as Map<String, dynamic>;

//         // Map backend user → your UserProfile (adjust field names if needed)
//         final profile = UserProfile(
//           displayName: (userJson['displayName'] ?? userJson['name'] ?? '') as String,
//           username: (userJson['username'] ?? '') as String,
//           email: (userJson['email'] ?? '') as String,
//           country: (userJson['country'] ?? '') as String,
//           bio: (userJson['bio'] ?? '') as String,
//           skills: List<String>.from(userJson['skills'] ?? const []),
//           interests: List<String>.from(userJson['interests'] ?? const []),
//           githubUrl: (userJson['githubUrl'] ?? '') as String,
//         );

//         final app = AppState();
//         app.profile = profile;
//         app.isSignedIn = true;
//         app.authToken = token; // we'll add this field in AppState

//         return true; // login success
//       }

//       // ---- CASE 1: user does not exist (404) ----
//       if (res.statusCode == 404) {
//         _showSnack(context, 'User does not exist');
//         return false;
//       }

//       // ---- CASE 3: wrong password (401) ----
//       if (res.statusCode == 401) {
//         // your backend sends { msg: "Invalid credentials" }
//         _showSnack(context, 'Incorrect email/username or password');
//         return false;
//       }

//       // ---- CASE 2: blocked (403) ----
//       if (res.statusCode == 403) {
//         _showSnack(context, 'Your account has been blocked by admin.');
//         return false;
//       }

//       // ---- Any other error ----
//       _showSnack(context, 'Something went wrong (${res.statusCode}).');
//       return false;
//     } catch (e) {
//       _showSnack(context, 'Could not connect to server. Check your network.');
//       return false;
//     }
//   }

//   void _showSnack(BuildContext context, String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg)),
//     );
//   }
// }


// // lib/api/auth_api.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../models/user_profile.dart';

// class AuthException implements Exception {
//   final String message;
//   AuthException(this.message);

//   @override
//   String toString() => message;
// }

// class AuthApi {
//   static const String _baseUrl = 'https://devsta-backend.onrender.com';
//   static const String _loginPath = '/api/auth/login';

//   /// Calls POST /api/auth/login
//   /// Returns (UserProfile, token) on success
//   Future<(UserProfile, String)> login({
//     required String identifier,
//     required String password,
//   }) async {
//     final uri = Uri.parse('$_baseUrl$_loginPath');

//     try {
//       final res = await http.post(
//         uri,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'emailOrUsername': identifier,
//           'password': password,
//         }),
//       );

//       // ---- SUCCESS 200 ----
//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body) as Map<String, dynamic>;
//         final token = data['token'] as String;
//         final userJson = data['user'] as Map<String, dynamic>;

//         final profile = UserProfile(
//           displayName:
//               (userJson['displayName'] ?? userJson['name'] ?? '') as String,
//           username: (userJson['username'] ?? '') as String,
//           email: (userJson['email'] ?? '') as String,
//           country: (userJson['country'] ?? '') as String,
//           bio: (userJson['bio'] ?? '') as String,
//           skills: List<String>.from(userJson['skills'] ?? const []),
//           interests: List<String>.from(userJson['interests'] ?? const []),
//           githubUrl: (userJson['githubUrl'] ?? '') as String,
//         );

//         return (profile, token);
//       }

//       // ---- MAP BACKEND STATUSES TO MESSAGES ----
//       if (res.statusCode == 404) {
//         // { msg: "User does not exist" }
//         throw AuthException('User does not exist');
//       }

//       if (res.statusCode == 401) {
//         // { msg: "Invalid credentials" }
//         throw AuthException('Incorrect email/username or password');
//       }

//       if (res.statusCode == 403) {
//         // blocked by admin
//         throw AuthException('Your account has been blocked by admin.');
//       }

//       throw AuthException(
//         'Something went wrong (${res.statusCode}). Please try again.',
//       );
//     } catch (e) {
//       if (e is AuthException) rethrow;
//       throw AuthException(
//         'Could not connect to server. Check your network and try again.',
//       );
//     }
//   }
// }



// lib/api/auth_api.dart
import '../models/user_profile.dart';
import 'api_client.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthApi {
  final ApiClient _client = ApiClient.instance;

  /// POST /api/users/login
  Future<(UserProfile, String)> login({
    required String email,
    required String password,
  }) async {
    try {
      final data = await _client.post(
        '/api/users/login',
        body: {
          'email': email,    // 👈 same shape as web
          'password': password,
        },
      );

      final token = data['token'] as String?;
      final userJson = data['user'] as Map<String, dynamic>?;

      if (token == null || userJson == null) {
        throw AuthException('Invalid login response from server.');
      }

      final profile = UserProfile(
        displayName:
            (userJson['displayName'] ?? userJson['name'] ?? '') as String,
        username: (userJson['username'] ?? '') as String,
        email: (userJson['email'] ?? '') as String,
        country: (userJson['country'] ?? '') as String,
        bio: (userJson['bio'] ?? '') as String,
        skills: List<String>.from(userJson['skills'] ?? const []),
        interests: List<String>.from(userJson['interests'] ?? const []),
        githubUrl: (userJson['githubUrl'] ?? '') as String,
      );

      return (profile, token);
    } catch (e) {
      final msg = e.toString();

      // Basic mapping – backend will send error JSON as well
      if (msg.contains('401')) {
        throw AuthException('Incorrect email or password');
      }
      if (msg.contains('404')) {
        throw AuthException('User not found');
      }

      throw AuthException(
        'Login failed. Please try again.',
      );
    }
  }
}
