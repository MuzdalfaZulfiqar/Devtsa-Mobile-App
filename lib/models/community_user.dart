// lib/models/community_user.dart
class CommunityUser {
  final String id;
  final String name;
  final String? primaryRole;
  final String? avatarUrl;
  final List<String> topSkills;

  /// "none" | "pending_sent" | "pending_received" | "accepted" | "declined" | "cancelled"
  final String connectionStatus;
  final String? requestId;
  final String? direction; // "outgoing" | "incoming"

  CommunityUser({
    required this.id,
    required this.name,
    this.primaryRole,
    this.avatarUrl,
    this.topSkills = const [],
    this.connectionStatus = 'none',
    this.requestId,
    this.direction,
  });

  bool get isConnected => connectionStatus == 'accepted';
  bool get isPendingSent => connectionStatus == 'pending_sent';
  bool get isPendingReceived => connectionStatus == 'pending_received';

  factory CommunityUser.fromJson(Map<String, dynamic> json) {
    final connection = (json['connection'] is Map)
        ? (json['connection'] as Map<String, dynamic>)
        : null;

    return CommunityUser(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      primaryRole: json['primaryRole']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      topSkills: (json['topSkills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      connectionStatus:
          (connection?['connectionStatus'] as String?) ?? 'none',
      requestId: connection?['requestId']?.toString(),
      direction: connection?['direction']?.toString(),
    );
  }

  CommunityUser copyWith({
    String? connectionStatus,
    String? requestId,
    String? direction,
  }) {
    return CommunityUser(
      id: id,
      name: name,
      primaryRole: primaryRole,
      avatarUrl: avatarUrl,
      topSkills: topSkills,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      requestId: requestId ?? this.requestId,
      direction: direction ?? this.direction,
    );
  }
}
