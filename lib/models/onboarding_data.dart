// lib/models/onboarding_data.dart

class OnboardingData {
  final String name;
  final String email;
  final String? phone;
  final String? experienceLevel;
  final String? primaryRole;
  final List<String> topSkills;
  final String? githubUrl;
  final String? resumeUrl;
  final bool onboardingCompleted;
  final DateTime? updatedAt;

  OnboardingData({
    required this.name,
    required this.email,
    this.phone,
    this.experienceLevel,
    this.primaryRole,
    List<String>? topSkills,
    this.githubUrl,
    this.resumeUrl,
    this.onboardingCompleted = false,
    this.updatedAt,
  }) : topSkills = topSkills ?? const [];

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] as String?)?.trim().isEmpty == true
          ? null
          : json['phone'] as String?,
      experienceLevel: (json['experienceLevel'] as String?)?.isEmpty == true
          ? null
          : json['experienceLevel'] as String?,
      primaryRole: (json['primaryRole'] as String?)?.isEmpty == true
          ? null
          : json['primaryRole'] as String?,
      topSkills: (json['topSkills'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      githubUrl: (json['githubUrl'] as String?)?.isEmpty == true
          ? null
          : json['githubUrl'] as String?,
      resumeUrl: (json['resumeUrl'] as String?)?.isEmpty == true
          ? null
          : json['resumeUrl'] as String?,
      onboardingCompleted: json['onboardingCompleted'] == true,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson({bool complete = false}) {
    final map = <String, dynamic>{};

    if (name.trim().isNotEmpty) {
      map['name'] = name.trim();
    }
    if (phone != null && phone!.trim().isNotEmpty) {
      map['phone'] = phone!.trim();
    }
    if (experienceLevel != null && experienceLevel!.isNotEmpty) {
      map['experienceLevel'] = experienceLevel;
    }
    if (primaryRole != null && primaryRole!.isNotEmpty) {
      map['primaryRole'] = primaryRole;
    }
    if (topSkills.isNotEmpty) {
      map['topSkills'] = topSkills;
    }
    if (githubUrl != null && githubUrl!.trim().isNotEmpty) {
      map['githubUrl'] = githubUrl!.trim();
    }

    map['complete'] = complete;

    return map;
  }

  OnboardingData copyWith({
    String? name,
    String? email,
    String? phone,
    String? experienceLevel,
    String? primaryRole,
    List<String>? topSkills,
    String? githubUrl,
    String? resumeUrl,
    bool? onboardingCompleted,
    DateTime? updatedAt,
  }) {
    return OnboardingData(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      primaryRole: primaryRole ?? this.primaryRole,
      topSkills: topSkills ?? this.topSkills,
      githubUrl: githubUrl ?? this.githubUrl,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
