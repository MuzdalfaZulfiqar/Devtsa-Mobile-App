// // lib/api/api_client.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiClient {
//   ApiClient._();
//   static final ApiClient instance = ApiClient._();

//   // TODO: CHANGE THIS
//   static const String _baseUrl = 'https://devsta-backend.onrender.com'; // or your IP/port

//   String? _token;

//   void setToken(String? token) {
//     _token = token;
//   }

//   Map<String, String> _headers({bool withAuth = false}) {
//     final headers = <String, String>{
//       'Content-Type': 'application/json',
//     };
//     if (withAuth && _token != null) {
//       headers['Authorization'] = 'Bearer $_token';
//     }
//     return headers;
//   }

//   Future<Map<String, dynamic>> post(
//     String path, {
//     Map<String, dynamic>? body,
//     bool withAuth = false,
//   }) async {
//     final uri = Uri.parse('$_baseUrl$path');
//     final res = await http.post(
//       uri,
//       headers: _headers(withAuth: withAuth),
//       body: jsonEncode(body ?? {}),
//     );

//     if (res.statusCode >= 200 && res.statusCode < 300) {
//       if (res.body.isEmpty) return {};
//       return jsonDecode(res.body) as Map<String, dynamic>;
//     } else {
//       throw Exception('POST $path failed: ${res.statusCode} ${res.body}');
//     }
//   }

//   Future<Map<String, dynamic>> get(
//     String path, {
//     Map<String, dynamic>? query,
//     bool withAuth = false,
//   }) async {
//     final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: query);
//     final res = await http.get(uri, headers: _headers(withAuth: withAuth));

//     if (res.statusCode >= 200 && res.statusCode < 300) {
//       if (res.body.isEmpty) return {};
//       return jsonDecode(res.body) as Map<String, dynamic>;
//     } else {
//       throw Exception('GET $path failed: ${res.statusCode} ${res.body}');
//     }
//   }
// }

// lib/api/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const String _baseUrl = 'https://devsta-backend.onrender.com';

  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Map<String, String> _headers({bool withAuth = false}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (withAuth && _token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool withAuth = false,
  }) async {
    final uri = Uri.parse('$_baseUrl$path');

    print('[ApiClient] POST $uri');
    print('[ApiClient] Body: $body  withAuth=$withAuth');

    final res = await http.post(
      uri,
      headers: _headers(withAuth: withAuth),
      body: jsonEncode(body ?? {}),
    );

    print('[ApiClient] Status: ${res.statusCode}');
    print('[ApiClient] Response: ${res.body}');

    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return {};
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('POST $path failed: ${res.statusCode} ${res.body}');
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
    bool withAuth = false,
  }) async {
    final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: query);

    print('[ApiClient] GET $uri  withAuth=$withAuth');

    final res = await http.get(uri, headers: _headers(withAuth: withAuth));

    print('[ApiClient] Status: ${res.statusCode}');
    print('[ApiClient] Response: ${res.body}');

    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return {};
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('GET $path failed: ${res.statusCode} ${res.body}');
    }
  }
}
