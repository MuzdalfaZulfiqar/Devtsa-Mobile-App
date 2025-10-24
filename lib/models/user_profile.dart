
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
}
