// // lib/services/community_api.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../config/backend_config.dart';
// import '../models/community_user.dart';

// class CommunityApi {
//   /// GET /api/connections
//   /// Backend returns: { page, limit, total, totalPages, items: [...] }
//   static Future<List<CommunityUser>> fetchExploreUsers(
//     String authToken, {
//     int page = 1,
//     int limit = 20,
//   }) async {
//     // Now calling /api/connections
//     final uri = Uri.parse(
//       '${BackendConfig.baseUrl}/api/connections?page=$page&limit=$limit',
//     );

//     final res = await http.get(
//       uri,
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $authToken',
//       },
//     );

//     if (res.statusCode != 200) {
//       throw Exception(
//         'Failed to load explore users: ${res.statusCode} ${res.body}',
//       );
//     }

//     final decoded = jsonDecode(res.body);

//     if (decoded is! Map<String, dynamic>) {
//       throw Exception('Unexpected response shape: ${res.body}');
//     }

//     final List<dynamic> items =
//         (decoded['items'] as List<dynamic>? ?? <dynamic>[]);

//     return items
//         .map((dynamic e) => CommunityUser.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   /// POST /api/connections/requests
//   /// Body: { "to": "<userId>" }
//   /// Response: { request: {...}, autoAcceptedFromInverse?: bool }
//   ///
//   /// Returns the new connectionStatus: "accepted" or "pending_sent"
//   static Future<String> sendConnectionRequest(
//     String authToken,
//     String targetUserId,
//   ) async {
//     // Now calling /api/connections/requests
//     final uri = Uri.parse(
//       '${BackendConfig.baseUrl}/api/connections/requests',
//     );

//     final res = await http.post(
//       uri,
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $authToken',
//       },
//       body: jsonEncode(<String, dynamic>{
//         'to': targetUserId,
//       }),
//     );

//     if (res.statusCode != 200 && res.statusCode != 201) {
//       throw Exception(
//         'Failed to send connection request: ${res.statusCode} ${res.body}',
//       );
//     }

//     final decoded = jsonDecode(res.body);

//     if (decoded is! Map<String, dynamic>) {
//       throw Exception('Unexpected response when sending request: ${res.body}');
//     }

//     final bool autoAccepted =
//         (decoded['autoAcceptedFromInverse'] as bool?) ?? false;

//     // mirror web: if inverse pending existed -> accepted, else pending_sent
//     return autoAccepted ? 'accepted' : 'pending_sent';
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/backend_config.dart';
import '../models/community_user.dart';

class CommunityApi {
  /// GET /api/connections
  /// backend returns: { page, limit, total, totalPages, items: [...] }
  static Future<List<CommunityUser>> fetchExploreUsers(
    String authToken, {
    int page = 1,
    int limit = 20,
  }) async {
    // Make sure BackendConfig.baseUrl = 'https://devsta-backend.onrender.com/api'
    final uri = Uri.parse(
      '${BackendConfig.baseUrl}/api/connections?page=$page&limit=$limit',
    );

    final res = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load explore users: ${res.statusCode}');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final List<dynamic> items = (body['items'] as List<dynamic>? ?? []);

    return items.map((e) => CommunityUser.fromJson(e)).toList();
  }

  /// POST /api/connections/requests
  /// Body: { "to": "<userId>" }
  /// Response: { request: {...}, autoAcceptedFromInverse?: bool }
  ///
  /// Returns the new connectionStatus: "accepted" or "pending_sent"
  static Future<String> sendConnectionRequest(
    String authToken,
    String targetUserId,
  ) async {
    final uri = Uri.parse(
      '${BackendConfig.baseUrl}/api/connections/requests',
    );

    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({
        'to': targetUserId,
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(
        'Failed to send connection request: ${res.statusCode} ${res.body}',
      );
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final bool autoAccepted =
        (body['autoAcceptedFromInverse'] as bool?) ?? false;

    // mirror web: if inverse pending existed -> accepted, else pending_sent
    return autoAccepted ? 'accepted' : 'pending_sent';
  }

  /// DELETE /api/connections/requests/:id
  /// Sender (from) can cancel their own pending request.
  static Future<void> cancelConnectionRequest(
    String authToken,
    String requestId,
  ) async {
    final uri = Uri.parse(
      '${BackendConfig.baseUrl}/api/connections/requests/$requestId',
    );

    final res = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (res.statusCode != 200) {
      throw Exception(
        'Failed to cancel request: ${res.statusCode} ${res.body}',
      );
    }
  }
}
