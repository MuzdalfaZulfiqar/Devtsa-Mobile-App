// lib/models/user.dart
class DevstaUser {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? experienceLevel;
  final String? primaryRole;
  final List<String> topSkills;
  final bool onboardingCompleted;

  DevstaUser({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.experienceLevel,
    this.primaryRole,
    this.topSkills = const [],
    this.onboardingCompleted = false,
  });

  factory DevstaUser.fromJson(Map<String, dynamic> json) {
    return DevstaUser(
      id: (json['_id'] ?? json['id']).toString(),
      email: (json['email'] ?? '').toString(),
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      experienceLevel: json['experienceLevel']?.toString(),
      primaryRole: json['primaryRole']?.toString(),
      topSkills: (json['topSkills'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      onboardingCompleted: json['onboardingCompleted'] == true,
    );
  }
}
