// // lib/models/user.dart
// class DevstaUser {
//   final String id;
//   final String email;
//   final String? name;
//   final String? phone;
//   final String? experienceLevel;
//   final String? primaryRole;
//   final List<String> topSkills;
//   final bool onboardingCompleted;

//   DevstaUser({
//     required this.id,
//     required this.email,
//     this.name,
//     this.phone,
//     this.experienceLevel,
//     this.primaryRole,
//     this.topSkills = const [],
//     this.onboardingCompleted = false,
//   });

//   factory DevstaUser.fromJson(Map<String, dynamic> json) {
//     return DevstaUser(
//       id: (json['_id'] ?? json['id']).toString(),
//       email: (json['email'] ?? '').toString(),
//       name: json['name']?.toString(),
//       phone: json['phone']?.toString(),
//       experienceLevel: json['experienceLevel']?.toString(),
//       primaryRole: json['primaryRole']?.toString(),
//       topSkills: (json['topSkills'] as List?)
//               ?.map((e) => e.toString())
//               .toList() ??
//           [],
//       onboardingCompleted: json['onboardingCompleted'] == true,
//     );
//   }
// }

// lib/models/user.dart
class DevstaUser {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String experienceLevel;
  final String primaryRole;
  final List<String> topSkills;
  final bool onboardingCompleted;

  // GitHub info
  final bool githubConnected;
  final Map<String, dynamic> githubProfile;
  final List<Map<String, dynamic>> githubRepos;
  final Map<String, dynamic> githubStats;

  // Skills
  final bool skillsValidated;
  final Map<String, double> validatedSkills;

  // Resume
  final String resumeUrl;
  final String resumePublicId;
  final String resumeFileType;
  final int resumeFileSize;

  // Quiz / profile
  final bool hasAttemptedQuiz;
  final int latestQuizScore;
  final int latestQuizOutOf;
  final double profileScore;

  // Admin / status
  final bool isBlocked;

  DevstaUser({
    required this.id,
    required this.email,
    this.name = '',
    this.phone = '',
    this.experienceLevel = '',
    this.primaryRole = '',
    this.topSkills = const [],
    this.onboardingCompleted = false,
    this.githubConnected = false,
    this.githubProfile = const {},
    this.githubRepos = const [],
    this.githubStats = const {},
    this.skillsValidated = false,
    this.validatedSkills = const {},
    this.resumeUrl = '',
    this.resumePublicId = '',
    this.resumeFileType = '',
    this.resumeFileSize = 0,
    this.hasAttemptedQuiz = false,
    this.latestQuizScore = 0,
    this.latestQuizOutOf = 0,
    this.profileScore = 0.0,
    this.isBlocked = false,
  });

  factory DevstaUser.fromJson(Map<String, dynamic> json) {
    return DevstaUser(
      id: (json['_id'] ?? json['id']).toString(),
      email: (json['email'] ?? '').toString(),
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      experienceLevel: json['experienceLevel']?.toString() ?? '',
      primaryRole: json['primaryRole']?.toString() ?? '',
      topSkills: (json['topSkills'] as List?)?.map((e) => e.toString()).toList() ?? [],
      onboardingCompleted: json['onboardingCompleted'] == true,
      githubConnected: json['githubConnected'] == true,
      githubProfile: json['githubProfile'] != null
          ? Map<String, dynamic>.from(json['githubProfile'])
          : {},
      githubRepos: (json['githubRepos'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],
      githubStats: json['githubStats'] != null
          ? Map<String, dynamic>.from(json['githubStats'])
          : {},
      skillsValidated: json['skillsValidated'] == true,
      validatedSkills: json['validatedSkills'] != null
          ? Map<String, double>.from(
              (json['validatedSkills'] as Map)
                  .map((k, v) => MapEntry(k.toString(), (v as num).toDouble())))
          : {},
      resumeUrl: json['resumeUrl']?.toString() ?? '',
      resumePublicId: json['resumePublicId']?.toString() ?? '',
      resumeFileType: json['resumeFileType']?.toString() ?? '',
      resumeFileSize: json['resumeFileSize'] as int? ?? 0,
      hasAttemptedQuiz: json['hasAttemptedQuiz'] == true,
      latestQuizScore: json['latestQuizScore'] as int? ?? 0,
      latestQuizOutOf: json['latestQuizOutOf'] as int? ?? 0,
      profileScore: (json['profileScore'] as num?)?.toDouble() ?? 0.0,
      isBlocked: json['isBlocked'] == true,
    );
  }

  DevstaUser? copyWith({required validatedSkills, required profileScore, required bool skillsValidated}) {}
}
