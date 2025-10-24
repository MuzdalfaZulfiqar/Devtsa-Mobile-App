class UserProfile {
  String displayName;
  String username;          // NEW
  String email;
  String country;           // NEW
  String bio;
  List<String> skills;
  List<String> interests;   // NEW
  String githubUrl;
  String? resumeLabel; // visual-only

  UserProfile({
    this.displayName = '',
    this.username = '',
    this.email = '',
    this.country = '',
    this.bio = '',
    this.skills = const [],
    this.interests = const [],
    this.githubUrl = '',
    this.resumeLabel,
  });
}
