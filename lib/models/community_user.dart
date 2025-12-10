// lib/models/community_user.dart
class CommunityUser {
  final String id;
  final String name;
  final String? headline;
  final String? avatarUrl;
  final List<String> skills;
  final bool isConnected;
  final bool requestPending;

  CommunityUser({
    required this.id,
    required this.name,
    this.headline,
    this.avatarUrl,
    this.skills = const [],
    this.isConnected = false,
    this.requestPending = false,
  });

  factory CommunityUser.fromJson(Map<String, dynamic> json) {
    // Adjust keys according to your backend response
    return CommunityUser(
      id: json['_id']?.toString() ?? json['id'].toString(),
      name: json['name'] ?? json['fullName'] ?? 'Unknown',
      headline: json['headline'] ?? json['title'],
      avatarUrl: json['avatarUrl'] ?? json['profileImage'],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      isConnected: json['isConnected'] == true,
      requestPending: json['requestPending'] == true,
    );
  }

  CommunityUser copyWith({
    bool? isConnected,
    bool? requestPending,
  }) {
    return CommunityUser(
      id: id,
      name: name,
      headline: headline,
      avatarUrl: avatarUrl,
      skills: skills,
      isConnected: isConnected ?? this.isConnected,
      requestPending: requestPending ?? this.requestPending,
    );
  }
}
