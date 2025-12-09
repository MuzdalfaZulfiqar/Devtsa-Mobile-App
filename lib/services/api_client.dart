
// lib/services/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/backend_config.dart'; // where you keep baseUrl

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal();

  final http.Client _client = http.Client();
  String? _authToken;

  /// Set or clear the current auth token used on requests.
  void setAuthToken(String? token) {
    _authToken = token;
  }

  String? get authToken => _authToken;

  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse('${BackendConfig.baseUrl}$path')
        .replace(queryParameters: query?.map((k, v) => MapEntry(k, '$v')));
  }

  Map<String, String> _buildHeaders({String? tokenOverride}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final token = tokenOverride ?? _authToken;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    String? token,
    Map<String, dynamic>? query,
  }) async {
    final uri = _buildUri(path, query);
    final res = await _client.get(
      uri,
      headers: _buildHeaders(tokenOverride: token),
    );

    Map<String, dynamic> data;
    try {
      data = json.decode(res.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(
        'Server returned invalid response',
        statusCode: res.statusCode,
      );
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      final msg = data['msg']?.toString() ??
          data['message']?.toString() ??
          'Request failed (${res.statusCode})';
      throw ApiException(msg, statusCode: res.statusCode);
    }

    return data;
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = _buildUri(path);
    final res = await _client.post(
      uri,
      headers: _buildHeaders(tokenOverride: token),
      body: json.encode(body ?? {}),
    );

    Map<String, dynamic> data;
    try {
      data = json.decode(res.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(
        'Server returned invalid response',
        statusCode: res.statusCode,
      );
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      final msg = data['msg']?.toString() ??
          data['message']?.toString() ??
          'Request failed (${res.statusCode})';
      throw ApiException(msg, statusCode: res.statusCode);
    }

    return data;
  }

  // We will use this later for resume upload / onboarding
  Future<Map<String, dynamic>> multipart(
    String path, {
    Map<String, String>? fields,
    String? token,
    Map<String, http.MultipartFile>? files,
    String method = 'POST',
  }) async {
    final uri = _buildUri(path);
    final request = http.MultipartRequest(method, uri)
      ..fields.addAll(fields ?? {});

    final authTokenToUse = token ?? _authToken;
    if (authTokenToUse != null && authTokenToUse.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $authTokenToUse';
    }

    if (files != null) {
      request.files.addAll(files.values);
    }

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);

    Map<String, dynamic> data;
    try {
      data = json.decode(res.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(
        'Server returned invalid response',
        statusCode: res.statusCode,
      );
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      final msg = data['msg']?.toString() ??
          data['message']?.toString() ??
          'Request failed (${res.statusCode})';
      throw ApiException(msg, statusCode: res.statusCode);
    }

    return data;
  }
}
