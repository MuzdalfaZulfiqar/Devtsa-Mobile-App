
class UserProfile {
  String displayName;
  String username;
  String password; // <--- added password
  String email;
  String country;
  String bio;
  List<String> skills;
  List<String> interests;
  String githubUrl;
  String? resumeLabel;

  // Optional extra fields
  String? phone;
  String? linkedin;

  UserProfile({
    this.displayName = '',
    this.username = '',
    this.password = '', // <--- initialize password
    this.email = '',
    this.country = '',
    this.bio = '',
    this.skills = const [],
    this.interests = const [],
    this.githubUrl = '',
    this.resumeLabel,
    this.phone,
    this.linkedin,
  });

  // ✅ from backend JSON → UserProfile
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      displayName: json['displayName'] ?? json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      country: json['country'] ?? '',
      bio: json['bio'] ?? '',
      skills: (json['skills'] as List?)?.map((e) => e.toString()).toList() ?? [],
      interests:
          (json['interests'] as List?)?.map((e) => e.toString()).toList() ?? [],
      githubUrl: json['githubUrl'] ?? '',
      resumeLabel: json['resumeLabel'],
      phone: json['phone'],
      linkedin: json['linkedin'],
    );
  }

  // ✅ UserProfile → JSON (for signup / update)
  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'username': username,
      'email': email,
      'country': country,
      'bio': bio,
      'skills': skills,
      'interests': interests,
      'githubUrl': githubUrl,
      'resumeLabel': resumeLabel,
      'phone': phone,
      'linkedin': linkedin,
      // sending password only if needed
      'password': password,
    };
  }
}


