// import 'package:flutter/material.dart';
// import '../../widgets/app_text_field.dart';
// import '../../widgets/primary_button.dart';
// import '../../state/app_state.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final idC = TextEditingController();
//   final pwdC = TextEditingController();

//   @override
//   void dispose() {
//     idC.dispose();
//     pwdC.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = Theme.of(context).textTheme;
//     final c = Theme.of(context).colorScheme;

//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 400),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text('DevSta',
//                       style: t.headlineMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: c.primary),
//                       textAlign: TextAlign.center),
//                   const SizedBox(height: 24),
//                   Text('Welcome Back',
//                       style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.center),
//                   const SizedBox(height: 8),
//                   Text('Sign in to continue',
//                       style: t.bodyMedium?.copyWith(color: Colors.grey[700]),
//                       textAlign: TextAlign.center),
//                   const SizedBox(height: 32),

//                   AppTextField(controller: idC, label: 'Email or Username'),
//                   const SizedBox(height: 16),
//                   AppTextField(controller: pwdC, label: 'Password', obscure: true),
//                   const SizedBox(height: 24),

//                   PrimaryButton(
//   text: 'Sign In',
//   onPressed: () {
//     final id = idC.text.trim();
//     final pwd = pwdC.text.trim();
//     final app = AppState();
//     final user = app.registered;

//     if (user == null || user.username.toLowerCase() != id.toLowerCase()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No account found with that username')),
//       );
//       return; // just return to stop further execution
//     }

//     if (user.password != pwd) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Incorrect password')),
//       );
//       return; // stop execution
//     }

//     app.signInWithIdentifier(id);
//     Navigator.pushReplacementNamed(context, '/home');
//   },
// ),


//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text('New here? ', style: TextStyle(color: Colors.grey)),
//                       TextButton(onPressed: () => Navigator.pushNamed(context, '/signup/step1'),
//                         child: const Text('Create an account'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// import '../../api/auth_api.dart';
// import '../../state/app_state.dart';
// import '../../widgets/primary_button.dart';
// import '../../widgets/app_text_field.dart';
// import 'package:flutter/material.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final idC = TextEditingController();
//   final pwdC = TextEditingController();
//   bool _loading = false;

//   @override
//   void dispose() {
//     idC.dispose();
//     pwdC.dispose();
//     super.dispose();
//   }

//   Future<void> _handleLogin() async {
//     final id = idC.text.trim();
//     final pwd = pwdC.text.trim();

//     if (id.isEmpty || pwd.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter your username/email and password')),
//       );
//       return;
//     }

//     setState(() => _loading = true);
//     try {
//       final authApi = AuthApi();
//       final (user, token) = await authApi.login(
//         identifier: id,
//         password: pwd,
//       );

//       AppState().setSession(user: user, token: token);
//       if (!mounted) return;
//       Navigator.pushReplacementNamed(context, '/home');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Login failed: $e')),
//       );
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = Theme.of(context).textTheme;
//     final c = Theme.of(context).colorScheme;

//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 400),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     'DevSta',
//                     style: t.headlineMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: c.primary,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 24),
//                   Text(
//                     'Welcome Back',
//                     style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Sign in to continue',
//                     style: t.bodyMedium?.copyWith(color: Colors.grey[700]),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 32),

//                   AppTextField(controller: idC, label: 'Email or Username'),
//                   const SizedBox(height: 16),
//                   AppTextField(controller: pwdC, label: 'Password', obscure: true),
//                   const SizedBox(height: 24),

//                   PrimaryButton(
//                     text: _loading ? 'Signing In...' : 'Sign In',
//                     onPressed: _loading ? () {} : _handleLogin,
//                     disabled: _loading,
//                   ),

//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text('New here? ', style: TextStyle(color: Colors.grey)),
//                       TextButton(
//                         onPressed: () => Navigator.pushNamed(context, '/signup/step1'),
//                         child: const Text('Create an account'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// lib/features/auth/login_page.dart
import 'package:flutter/material.dart';

import '../../api/auth_api.dart';
import '../../state/app_state.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/app_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();
  final pwdC = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    emailC.dispose();
    pwdC.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
  final email = emailC.text.trim();
  final pwd = pwdC.text.trim();

  print('[LoginPage] Attempt login with email=$email');

  if (email.isEmpty || pwd.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter your email and password'),
      ),
    );
    return;
  }

  setState(() => _loading = true);
  try {
    final authApi = AuthApi();

    final (user, token) = await authApi.login(
      email: email,
      password: pwd,
    );

    print('[LoginPage] Login success, token length = ${token.length}');

    AppState().setSession(user: user, token: token);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  } on AuthException catch (e) {
    print('[LoginPage] AuthException: ${e.message}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message)),
    );
  } catch (e) {
    print('[LoginPage] Unexpected error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Something went wrong. Please try again.'),
      ),
    );
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'DevSta',
                    style: t.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: c.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome Back',
                    style: t.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: t.bodyMedium?.copyWith(color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  AppTextField(
                    controller: emailC,
                    label: 'Email', // same as web
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: pwdC,
                    label: 'Password',
                    obscure: true,
                  ),
                  const SizedBox(height: 24),

                  PrimaryButton(
                    text: _loading ? 'Signing In...' : 'Sign In',
                    onPressed: _loading ? () {} : _handleLogin,
                    disabled: _loading,
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'New here? ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/signup/step1'),
                        child: const Text('Create an account'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
