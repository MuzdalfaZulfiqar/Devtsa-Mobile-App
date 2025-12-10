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

  final String bio;
  final List<String> interests;

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
    this.bio = '', // new
    this.interests = const [], // new
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
       bio: json['bio']?.toString() ?? '', // new
      interests: (json['interests'] as List?)?.map((e) => e.toString()).toList() ?? [], // new
 
    );
  }

DevstaUser copyWith({
  Map<String, double>? validatedSkills,
  double? profileScore,
  bool? skillsValidated,
  String? name,
  String? email,
  String? phone,
  String? experienceLevel,
  String? primaryRole,
  List<String>? topSkills,
  bool? onboardingCompleted,
  bool? githubConnected,
  Map<String, dynamic>? githubProfile,
  List<Map<String, dynamic>>? githubRepos,
  Map<String, dynamic>? githubStats,
  String? resumeUrl,
  String? resumePublicId,
  String? resumeFileType,
  int? resumeFileSize,
  bool? hasAttemptedQuiz,
  int? latestQuizScore,
  int? latestQuizOutOf,
  bool? isBlocked,
   String? bio,
    List<String>? interests,
}) {
  return DevstaUser(
    id: id, // usually id should never change
    email: email ?? this.email,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    experienceLevel: experienceLevel ?? this.experienceLevel,
    primaryRole: primaryRole ?? this.primaryRole,
    topSkills: topSkills ?? this.topSkills,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    githubConnected: githubConnected ?? this.githubConnected,
    githubProfile: githubProfile ?? this.githubProfile,
    githubRepos: githubRepos ?? this.githubRepos,
    githubStats: githubStats ?? this.githubStats,
    skillsValidated: skillsValidated ?? this.skillsValidated,
    validatedSkills: validatedSkills ?? this.validatedSkills,
    resumeUrl: resumeUrl ?? this.resumeUrl,
    resumePublicId: resumePublicId ?? this.resumePublicId,
    resumeFileType: resumeFileType ?? this.resumeFileType,
    resumeFileSize: resumeFileSize ?? this.resumeFileSize,
    hasAttemptedQuiz: hasAttemptedQuiz ?? this.hasAttemptedQuiz,
    latestQuizScore: latestQuizScore ?? this.latestQuizScore,
    latestQuizOutOf: latestQuizOutOf ?? this.latestQuizOutOf,
    profileScore: profileScore ?? this.profileScore,
    isBlocked: isBlocked ?? this.isBlocked,
    bio: bio ?? this.bio,
      interests: interests ?? this.interests,
  );
}

}
