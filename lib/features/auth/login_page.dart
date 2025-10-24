import 'package:flutter/material.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../state/app_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final idC = TextEditingController(); // Email or Username
  final pwdC = TextEditingController(); // still visual-only

  @override
  void dispose() {
    idC.dispose();
    pwdC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 64, color: c.primary),
                  const SizedBox(height: 16),
                  Text('Welcome back', style: t.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in with your email or username',
                    style: t.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  AppTextField(controller: idC, label: 'Email or Username'),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: pwdC,
                    label: 'Password',
                    obscure: true,
                  ),
                  const SizedBox(height: 16),

                  PrimaryButton(
                    text: 'Continue',
                    onPressed: () {
                      final id = idC.text.trim();
                      if (id.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enter your email or username'),
                          ),
                        );
                        return;
                      }
                      final app = AppState();
                      if (!app.canLoginWith(id)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No account found. Please sign up first.',
                            ),
                          ),
                        );
                        return;
                      }
                      app.signInWithIdentifier(id);
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/signup/step1'),
                    child: const Text("Create an account"),
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
