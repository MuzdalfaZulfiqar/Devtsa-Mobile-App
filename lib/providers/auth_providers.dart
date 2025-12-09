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


// lib/providers/auth_provider.dart
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

  /// Initial setup: load token and current user
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

  /// Fetch the latest user data
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
}
