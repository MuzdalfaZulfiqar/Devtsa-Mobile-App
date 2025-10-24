import '../models/user_profile.dart';
import '../models/resume.dart';

class AppState {
  static final AppState _i = AppState._();
  AppState._();
  factory AppState() => _i;

  bool isSignedIn = false;

  // This is the active, signed-in user's profile
  UserProfile profile = UserProfile(
    displayName: 'Demo User',
    email: 'demo@example.com',
    skills: const ['Dart', 'Flutter'],
  );

  // For a simple demo, keep ONE registered account in memory
  // You could seed with empty values meaning "no account yet".
  UserProfile? registered; // NEW

  Resume resume = Resume(
    summary: 'Enthusiastic Flutter learner.',
    skills: const ['Dart', 'Flutter'],
  );

  // Called by Sign Up flow
  void register(UserProfile p) {
    registered = p;
  }

  // Accept either email OR username as the "identifier"
  bool canLoginWith(String identifier) {
    if (registered == null) return false;
    final id = identifier.trim().toLowerCase();
    return registered!.email.toLowerCase() == id ||
        registered!.username.toLowerCase() == id;
  }

  // On successful login, copy registered profile into active profile
  void signInWithIdentifier(String identifier) {
    if (registered != null) {
      profile = registered!;
    }
    isSignedIn = true;
  }

  void signOut() {
    isSignedIn = false;
  }
}
