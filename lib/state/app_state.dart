// import '../models/user_profile.dart';
// import '../models/resume.dart';

// class Post {
//   final UserProfile author;
//   final String content;
//   int likes;
//   List<String> comments;

//   Post({
//     required this.author,
//     required this.content,
//     this.likes = 0,
//     this.comments = const [],
//   });
// }

// class AppState {
//   static final AppState _i = AppState._();
//   AppState._();
//   factory AppState() => _i;

//   bool isSignedIn = false;

//   UserProfile profile = UserProfile(
//     displayName: 'Demo User',
//     email: 'demo@example.com',
//     skills: const ['Dart', 'Flutter'],
//   );

//   UserProfile? registered;

//   Resume resume = Resume(
//     summary: 'Enthusiastic Flutter learner.',
//     skills: const ['Dart', 'Flutter'],
//   );

//   // ---------------- Dummy Feed Section ----------------
//   List<UserProfile> dummyUsers = [
//     UserProfile(displayName: 'Alice Smith', username: 'alice', skills: ['Flutter', 'UI']),
//     UserProfile(displayName: 'Bob Johnson', username: 'bobby', skills: ['Python', 'AI']),
//     UserProfile(displayName: 'Charlie Lee', username: 'charlie', skills: ['Java', 'Backend']),
//   ];

//   List<Post> feed = [];

//   void seedFeed() {
//    feed = [
//   Post(author: dummyUsers[0], content: 'Just finished my Flutter project!'),
//   Post(author: dummyUsers[1], content: 'Learning AI is amazing. Any tips?'),
//   Post(author: dummyUsers[2], content: 'Backend APIs deployed successfully!'),
// ];

//   }

//   // ---------------- Add this inside AppState ----------------
// void addPost(String content) {
//   feed.insert(
//     0, // insert at the top of the feed
//     Post(author: profile, content: content),
//   );
// }


//   // ---------------- Existing Methods ----------------
//   void register(UserProfile p) {
//     registered = p;
//   }

//   bool canLoginWith(String identifier) {
//     if (registered == null) return false;
//     final id = identifier.trim().toLowerCase();
//     return registered!.email.toLowerCase() == id ||
//         registered!.username.toLowerCase() == id;
//   }

//   void signInWithIdentifier(String identifier) {
//     if (registered != null) {
//       profile = registered!;
//     }
//     isSignedIn = true;
//     seedFeed(); // Populate feed for demo
//   }

//   void signOut() {
//     isSignedIn = false;
//   }
// }


// import '../models/user_profile.dart';
// import '../models/resume.dart';
// import '../models/post.dart';

// class AppState {
//   static final AppState _i = AppState._();
//   AppState._();
//   factory AppState() => _i;

//   bool isSignedIn = false;

//   UserProfile profile = UserProfile(
//     displayName: 'Demo User',
//     email: 'demo@example.com',
//     skills: const ['Dart', 'Flutter'],
//   );

//   UserProfile? registered;

//   Resume resume = Resume(
//     summary: 'Enthusiastic Flutter learner.',
//     skills: const ['Dart', 'Flutter'],
//   );

//   // ---------------- Dummy Feed Section ----------------
//   List<UserProfile> dummyUsers = [
//     UserProfile(displayName: 'Alice Smith', username: 'alice', skills: ['Flutter', 'UI']),
//     UserProfile(displayName: 'Bob Johnson', username: 'bobby', skills: ['Python', 'AI']),
//     UserProfile(displayName: 'Charlie Lee', username: 'charlie', skills: ['Java', 'Backend']),
//   ];

// List<Post> feed = <Post>[]; // keep growable

// void seedFeed() {
//   feed = <Post>[
//     Post(author: dummyUsers[0], content: 'Just finished my Flutter project!'),
//     Post(author: dummyUsers[1], content: 'Learning AI is amazing. Any tips?'),
//     Post(author: dummyUsers[2], content: 'Backend APIs deployed successfully!'),
//   ].toList(growable: true); // ensures growable list for Dart Web
// }

// void addPost(String content) {
//   feed = List<Post>.from(feed); // ensure a new growable Dart list
//   feed.insert(0, Post(author: profile, content: content));
// }



//   // ---------------- Existing Methods ----------------
//   void register(UserProfile p) {
//     registered = p;
//   }

//   bool canLoginWith(String identifier) {
//     if (registered == null) return false;
//     final id = identifier.trim().toLowerCase();
//     return registered!.email.toLowerCase() == id ||
//         registered!.username.toLowerCase() == id;
//   }

//   void signInWithIdentifier(String identifier) {
//     if (registered != null) {
//       profile = registered!;
//     }
//     isSignedIn = true;
//     seedFeed(); // Populate feed for demo
//   }

//   void signOut() {
//     isSignedIn = false;
//   }
// }



// // lib/state/app_state.dart
// import '../models/user_profile.dart';
// import '../models/resume.dart';
// import '../models/post.dart';
// import '../services/api_client.dart';

// class AppState {
//   static final AppState _i = AppState._();
//   AppState._();
//   factory AppState() => _i;

//   bool isSignedIn = false;
//   String? authToken;

//   UserProfile profile = UserProfile(
//     displayName: 'Demo User',
//     email: 'demo@example.com',
//     skills: const ['Dart', 'Flutter'],
//   );

//   UserProfile? registered;

//   Resume resume = Resume(
//     summary: 'Enthusiastic Flutter learner.',
//     skills: const ['Dart', 'Flutter'],
//   );

//   // ---------------- Dummy Feed Section ----------------
//   List<UserProfile> dummyUsers = [
//     UserProfile(
//       displayName: 'Alice Smith',
//       username: 'alice',
//       skills: ['Flutter', 'UI'],
//     ),
//     UserProfile(
//       displayName: 'Bob Johnson',
//       username: 'bobby',
//       skills: ['Python', 'AI'],
//     ),
//     UserProfile(
//       displayName: 'Charlie Lee',
//       username: 'charlie',
//       skills: ['Java', 'Backend'],
//     ),
//   ];

//   List<Post> feed = <Post>[];

//   void seedFeed() {
//     feed = <Post>[
//       Post(
//         author: dummyUsers[0],
//         content: 'Just finished my Flutter project!',
//       ),
//       Post(
//         author: dummyUsers[1],
//         content: 'Learning AI is amazing. Any tips?',
//       ),
//       Post(
//         author: dummyUsers[2],
//         content: 'Backend APIs deployed successfully!',
//       ),
//     ].toList(growable: true);
//   }

//   void addPost(String content) {
//     feed = List<Post>.from(feed);
//     feed.insert(0, Post(author: profile, content: content));
//   }

//   // --------- REAL SESSION FROM BACKEND ---------

//   void setSession({
//     required UserProfile user,
//     required String token,
//   }) {
//     profile = user;
//     authToken = token;
//     isSignedIn = true;
//     ApiClient().setToken(token);
//     seedFeed(); // later you can replace with real feed from backend
//   }

//   void clearSession() {
//     isSignedIn = false;
//     authToken = null;
//     ApiClient().setToken(null);
//      profile = UserProfile(
//       displayName: '',
//       email: '',
//       skills: const [],
//     );
//   }

//   // Old demo helpers (optional)
//   void register(UserProfile p) {
//     registered = p;
//   }

//   bool canLoginWith(String identifier) {
//     if (registered == null) return false;
//     final id = identifier.trim().toLowerCase();
//     return registered!.email.toLowerCase() == id ||
//         registered!.username.toLowerCase() == id;
//   }

//   void signInWithIdentifier(String identifier) {
//     if (registered != null) {
//       profile = registered!;
//     }
//     isSignedIn = true;
//     seedFeed();
//   }

//   void signOut() {
//     clearSession();
//   }
// }

// lib/state/app_state.dart
import '../models/user_profile.dart';
import '../models/resume.dart';
import '../models/post.dart';
import '../services/api_client.dart';

class AppState {
  static final AppState _i = AppState._();
  AppState._();
  factory AppState() => _i;

  bool isSignedIn = false;
  String? authToken;

  /// Current logged-in user's profile (used across the app)
  UserProfile profile = UserProfile(
    displayName: 'Demo User',
    email: 'demo@example.com',
    skills: const ['Dart', 'Flutter'],
  );

  /// For the old demo registration flow (optional)
  UserProfile? registered;

  Resume resume = Resume(
    summary: 'Enthusiastic Flutter learner.',
    skills: const ['Dart', 'Flutter'],
  );

  // ---------------- Dummy Feed Section ----------------
  List<UserProfile> dummyUsers = [
    UserProfile(
      displayName: 'Alice Smith',
      username: 'alice',
      skills: ['Flutter', 'UI'],
    ),
    UserProfile(
      displayName: 'Bob Johnson',
      username: 'bobby',
      skills: ['Python', 'AI'],
    ),
    UserProfile(
      displayName: 'Charlie Lee',
      username: 'charlie',
      skills: ['Java', 'Backend'],
    ),
  ];

  List<Post> feed = <Post>[];

 

  // --------- REAL SESSION FROM BACKEND ---------

  /// Use this when you already have a `UserProfile` (e.g. demo mode)
  void setSession({
    required UserProfile user,
    required String token,
  }) {
    profile = user;
    authToken = token;
    isSignedIn = true;

    // ✅ tell ApiClient to attach this token on authenticated calls
    ApiClient().setAuthToken(token);

    
  }

  /// Helper: build a UserProfile from backend "user" JSON and store session.
  ///
  /// Call this from login/signup after you get `{ token, user }` from Node.
  void setSessionFromBackend({
    required Map<String, dynamic> userJson,
    required String token,
  }) {
    final userProfile = UserProfile(
      displayName: (userJson['name'] ??
              userJson['username'] ??
              '') // fallback if name missing
          .toString(),
      email: (userJson['email'] ?? '').toString(),
      username: userJson['username']??''.toString(),
      skills: (userJson['topSkills'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );

    setSession(user: userProfile, token: token);
  }

  void clearSession() {
    isSignedIn = false;
    authToken = null;

    // ✅ clear auth token from ApiClient too
    ApiClient().setAuthToken(null);

    profile = UserProfile(
      displayName: '',
      email: '',
      skills: const [],
    );
  }

  // Old demo helpers (optional)
  void register(UserProfile p) {
    registered = p;
  }

  bool canLoginWith(String identifier) {
    if (registered == null) return false;
    final id = identifier.trim().toLowerCase();
    return registered!.email.toLowerCase() == id ||
        registered!.username.toLowerCase() == id;
  }

  void signInWithIdentifier(String identifier) {
    if (registered != null) {
      profile = registered!;
    }
    isSignedIn = true;
  
  }

  void signOut() {
    clearSession();
  }
}
