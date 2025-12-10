import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class PostService {
  final String backendUrl;
  PostService({required this.backendUrl});

  Future<String?> _getToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('devsta_token');
  }

  Map<String, String> _authHeader(String? token, {bool jsonHeader = true}) {
    final headers = <String, String>{};
    if (jsonHeader) headers['Content-Type'] = 'application/json';
    if (token != null && token.isNotEmpty) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  // CREATE POST (multipart/form-data)
  Future<Map<String, dynamic>> createPost({
    required String text,
    String visibility = 'public',
    List<File> mediaFiles = const [],
  }) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/createpost');
    final request = http.MultipartRequest('POST', uri);
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.fields['text'] = text;
    request.fields['visibility'] = visibility;

    for (final file in mediaFiles) {
      final stream = http.ByteStream(file.openRead());
      final length = await file.length();
      final filename = p.basename(file.path);
      final multipartFile = http.MultipartFile('media', stream, length, filename: filename);
      request.files.add(multipartFile);
    }

    final resp = await request.send();
    final body = await resp.stream.bytesToString();
    final json = jsonDecode(body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(json['msg'] ?? 'Failed to create post');
    }
    return json;
  }

  // GET FEED
  Future<Map<String, dynamic>> getFeed({int page = 1, int limit = 20}) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/listfeed?page=$page&limit=$limit');
    final resp = await http.get(uri, headers: _authHeader(token, jsonHeader: false));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(json['msg'] ?? 'Failed to fetch feed');
    }
    return json;
  }

  // LIKE
  Future<Map<String, dynamic>> likePost(String postId) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/$postId/like');
    final resp = await http.post(uri, headers: _authHeader(token, jsonHeader: false));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(json['msg'] ?? 'Failed to like post');
    }
    return json;
  }

  // UNLIKE
  Future<Map<String, dynamic>> unlikePost(String postId) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/$postId/like');
    final resp = await http.delete(uri, headers: _authHeader(token, jsonHeader: false));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(json['msg'] ?? 'Failed to unlike post');
    }
    return json;
  }

  // DELETE
  Future<Map<String, dynamic>> deletePost(String postId) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/$postId');
    final resp = await http.delete(uri, headers: _authHeader(token, jsonHeader: false));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(json['msg'] ?? 'Failed to delete post');
    }
    return json;
  }

  // UPDATE POST (multipart)
  Future<Map<String, dynamic>> updatePost(String postId, {required String text, List<File> newFiles = const [], List<String> removePublicIds = const []}) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/$postId');
    final request = http.MultipartRequest('PUT', uri);
    if (token != null && token.isNotEmpty) request.headers['Authorization'] = 'Bearer $token';

    request.fields['text'] = text;
    for (final id in removePublicIds) {
      request.fields['removePublicIds'] = id; // backend expects multiple fields possibly with same name
    }

    for (final file in newFiles) {
      final stream = http.ByteStream(file.openRead());
      final length = await file.length();
      final filename = p.basename(file.path);
      request.files.add(http.MultipartFile('media', stream, length, filename: filename));
    }

    final resp = await request.send();
    final body = await resp.stream.bytesToString();
    final json = jsonDecode(body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(json['msg'] ?? 'Failed to update post');
    }
    return json;
  }
}
