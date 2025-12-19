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

 /// CREATE POST (text + optional media)
  Future<Map<String, dynamic>> createPost({
    required String text,
    String visibility = 'public',
    List<File> mediaFiles = const [],
  }) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/createpost');

    final request = http.MultipartRequest('POST', uri);
    if (token != null && token.isNotEmpty) {
      request.headers.addAll(_authHeader(token));
    }

    request.fields['text'] = text;
    request.fields['visibility'] = visibility;

    // Attach files
    for (final file in mediaFiles) {
      final length = await file.length();
      final filename = p.basename(file.path);

      final multipartFile = http.MultipartFile(
        'media', // <-- Make sure backend expects this field name
        file.openRead().cast(),
        length,
        filename: filename,
      );
      request.files.add(multipartFile);
    }

    // Send request
    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    // Debugging: print backend response
    print('Response Status: ${streamedResponse.statusCode}');
    print('Response Body: $responseBody');

    final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;

    if (streamedResponse.statusCode < 200 || streamedResponse.statusCode >= 300) {
      throw Exception(jsonResponse['msg'] ?? 'Failed to create post');
    }

    return jsonResponse;
  }

Future<List<dynamic>> getAllPosts() async {
  final data = await getFeed();
  return data['posts'] ?? [];
}
  // GET FEED
  Future<Map<String, dynamic>> getFeed({int page = 1, int limit = 20}) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/listfeed?page=$page&limit=$limit');
    final resp = await http.get(uri, headers: _authHeader(token, jsonHeader: false));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) throw Exception(json['msg'] ?? 'Failed to fetch feed');
    return json;
  }

  // LIKE
  Future<Map<String, dynamic>> likePost(String postId) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/$postId/like');
    final resp = await http.post(uri, headers: _authHeader(token, jsonHeader: false));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) throw Exception(json['msg'] ?? 'Failed to like post');
    return json;
  }

  // UNLIKE
  Future<Map<String, dynamic>> unlikePost(String postId) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/$postId/like');
    final resp = await http.delete(uri, headers: _authHeader(token, jsonHeader: false));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) throw Exception(json['msg'] ?? 'Failed to unlike post');
    return json;
  }

  // DELETE
  Future<Map<String, dynamic>> deletePost(String postId) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/$postId');
    final resp = await http.delete(uri, headers: _authHeader(token, jsonHeader: false));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) throw Exception(json['msg'] ?? 'Failed to delete post');
    return json;
  }

  // UPDATE POST
  Future<Map<String, dynamic>> updatePost(
    String postId, {
    String? text,
    List<File> newFiles = const [],
    List<String> removePublicIds = const [],
  }) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/$postId');
    final request = http.MultipartRequest('PUT', uri);
    if (token != null && token.isNotEmpty) request.headers['Authorization'] = 'Bearer $token';

    if (text != null) request.fields['text'] = text;

    for (final id in removePublicIds) request.fields['removePublicIds[]'] = id;

    for (final file in newFiles) {
      final stream = http.ByteStream(file.openRead());
      final length = await file.length();
      final filename = p.basename(file.path);
      request.files.add(http.MultipartFile('media', stream, length, filename: filename));
    }

    final resp = await request.send();
    final body = await resp.stream.bytesToString();
    final json = jsonDecode(body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) throw Exception(json['msg'] ?? 'Failed to update post');
    return json;
  }

  // COMMENTS
  Future<Map<String, dynamic>> addComment(String postId, String text) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/$postId/comments');
    final resp = await http.post(uri,
        headers: _authHeader(token),
        body: jsonEncode({'text': text}));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) throw Exception(json['msg'] ?? 'Failed to add comment');
    return json;
  }

  Future<Map<String, dynamic>> listComments(String postId, {int page = 1, int limit = 20}) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/$postId/comments?page=$page&limit=$limit');
    final resp = await http.get(uri, headers: _authHeader(token, jsonHeader: false));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) throw Exception(json['msg'] ?? 'Failed to fetch comments');
    return json;
  }

  Future<Map<String, dynamic>> updateComment(String postId, String commentId, String text) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/$postId/comments/$commentId');
    final resp = await http.put(uri,
        headers: _authHeader(token),
        body: jsonEncode({'text': text}));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) throw Exception(json['msg'] ?? 'Failed to update comment');
    return json;
  }

  Future<Map<String, dynamic>> deleteComment(String postId, String commentId) async {
    final token = await _getToken();
    final uri = Uri.parse('$backendUrl/api/posts/$postId/comments/$commentId');
    final resp = await http.delete(uri, headers: _authHeader(token, jsonHeader: false));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode < 200 || resp.statusCode >= 300) throw Exception(json['msg'] ?? 'Failed to delete comment');
    return json;
  }
}
