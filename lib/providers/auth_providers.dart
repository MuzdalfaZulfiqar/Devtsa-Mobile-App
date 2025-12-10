// // lib/providers/auth_provider.dart
// import 'package:flutter/foundation.dart';
// import '../models/user.dart';
// import '../repositories/auth_repository.dart';

// class AuthProvider extends ChangeNotifier {
//   final AuthRepository _repo;

//   AuthProvider(this._repo);

//   String? _token;
//   DevstaUser? _user;
//   bool _initializing = true;
//   bool _loading = false;
//   String? _error;

//   String? get token => _token;
//   DevstaUser? get user => _user;
//   bool get isAuthenticated => _token != null && _user != null;
//   bool get initializing => _initializing;
//   bool get loading => _loading;
//   String? get error => _error;

//   Future<void> init() async {
//     _initializing = true;
//     notifyListeners();

//     try {
//       final saved = await _repo.loadSavedToken();
//       if (saved != null) {
//         final isValid = await _repo.validateToken(saved);
//         if (isValid) {
//           _token = saved;
//           _user = await _repo.fetchCurrentUser(saved);
//         } else {
//           await _repo.clearToken();
//         }
//       }
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _initializing = false;
//       notifyListeners();
//     }
//   }

//   Future<void> login(String email, String password) async {
//     _loading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       final (token, user) = await _repo.login(email, password);
//       _token = token;
//       _user = user;
//       await _repo.saveToken(token);
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> signup(String name, String email, String password) async {
//     _loading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       final (token, user) = await _repo.signup(name, email, password);
//       _token = token;
//       _user = user;
//       await _repo.saveToken(token);
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> logout() async {
//     _token = null;
//     _user = null;
//     await _repo.clearToken();
//     notifyListeners();
//   }
// }

import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;

  AuthProvider(this._repo);

  String? _token;
  DevstaUser? _user;
  bool _initializing = true;
  bool _loading = false;
  String? _error;

  String? get token => _token;
  DevstaUser? get user => _user;
  bool get isAuthenticated => _token != null && _user != null;
  bool get initializing => _initializing;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> init() async {
    _initializing = true;
    notifyListeners();

    try {
      final savedToken = await _repo.loadSavedToken();
      if (savedToken != null) {
        final isValid = await _repo.validateToken(savedToken);
        if (isValid) {
          _token = savedToken;
          _user = await _repo.fetchCurrentUser(savedToken);
        } else {
          await _repo.clearToken();
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _initializing = false;
      notifyListeners();
    }
  }

  Future<void> fetchCurrentUser() async {
    if (_token == null) return;
    _loading = true;
    notifyListeners();

    try {
      _user = await _repo.fetchCurrentUser(_token!);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> validateSkills() async {
    if (_token == null || _user == null) return;
    _loading = true;
    notifyListeners();

    try {
      final data = await _repo.validateSkills(_token!);
      _user = _user!.copyWith(
        validatedSkills: data['validated_skills'],
        profileScore: data['profile_score'],
        skillsValidated: true,
      );
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Login
  Future<void> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final (token, user) = await _repo.login(email, password);
      _token = token;
      _user = user;
      await _repo.saveToken(token);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Signup
  Future<void> signup(String name, String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final (token, user) = await _repo.signup(name, email, password);
      _token = token;
      _user = user;
      await _repo.saveToken(token);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout() async {
    _token = null;
    _user = null;
    await _repo.clearToken();
    notifyListeners();
  }

  /// NEW METHOD – Add this inside your AuthProvider class
Future<void> loginWithToken(String token) async {
  if (token.isEmpty) {
    _error = "Invalid token received";
    notifyListeners();
    return;
  }

  _loading = true;
  _error = null;
  notifyListeners();

  try {
    // Save token first
    await _repo.saveToken(token);
    _token = token;

    // Fetch fresh user data using the new token
    _user = await _repo.fetchCurrentUser(token);

    // Success!
    notifyListeners();
  } catch (e) {
    _error = "Failed to login with GitHub: ${e.toString()}";
    _token = null;
    _user = null;
    await _repo.clearToken();
    print("GitHub OAuth login failed: $e");
  } finally {
    _loading = false;
    notifyListeners();
  }
}
}

