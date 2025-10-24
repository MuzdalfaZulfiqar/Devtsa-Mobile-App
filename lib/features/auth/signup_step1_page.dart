import 'package:flutter/material.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../state/app_state.dart';
import '../../models/user_profile.dart';
import 'signup_step2_page.dart';

class SignUpStep1Page extends StatefulWidget {
  const SignUpStep1Page({super.key});
  @override
  State<SignUpStep1Page> createState() => _SignUpStep1PageState();
}

class _SignUpStep1PageState extends State<SignUpStep1Page> {
  final nameC = TextEditingController();
  final usernameC = TextEditingController();
  final passwordC = TextEditingController();
  final bioC = TextEditingController();
  String? country;

  final countries = const [
    'Pakistan', 'Saudi Arabia', 'United Kingdom', 'United States', 'France'
  ];

  @override
  void dispose() {
    nameC.dispose();
    usernameC.dispose();
    passwordC.dispose();
    bioC.dispose();
    super.dispose();
  }

  void _next() {
    final name = nameC.text.trim();
    final username = usernameC.text.trim();
    final password = passwordC.text.trim();
    final selectedCountry = country;
    final bio = bioC.text.trim();

    if (name.isEmpty) return _toast('Please enter your name');
    if (username.isEmpty) return _toast('Please choose a username');
    if (password.isEmpty) return _toast('Please enter a password');
    if (password.length < 6) return _toast('Password must be at least 6 characters');
    final usernameOk = RegExp(r'^[a-zA-Z0-9_\.]{3,20}$').hasMatch(username);
    if (!usernameOk) return _toast('Username must be 3–20 chars (letters, numbers, _ or .)');
    if (selectedCountry == null || selectedCountry.isEmpty) return _toast('Please select a country');

    final existing = AppState().registered;
    if (existing != null && existing.username.toLowerCase() == username.toLowerCase()) {
      return _toast('That username is already taken');
    }

    final partial = UserProfile(
      displayName: _titleCase(name),
      username: username.toLowerCase(),
      password: password,
      country: selectedCountry,
      bio: bio,
      email: '',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpStep2Page(),
        settings: RouteSettings(arguments: partial),
      ),
    );
  }

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _titleCase(String input) =>
      input.split(RegExp(r'\s+'))
          .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
          .join(' ');

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('DevSta',
                    style: t.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                Text('Create Account',
                    style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Step 1 of 2 — Basic Info',
                    style: t.bodyMedium?.copyWith(color: Colors.grey[700]),
                    textAlign: TextAlign.center),
                const SizedBox(height: 32),

                AppTextField(controller: nameC, label: 'Full Name', keyboardType: TextInputType.name),
                const SizedBox(height: 16),
                AppTextField(controller: usernameC, label: 'Username', keyboardType: TextInputType.name),
                const SizedBox(height: 16),
                AppTextField(controller: passwordC, label: 'Password', obscure: true),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: country,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                  items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => country = v),
                ),
                const SizedBox(height: 16),
                AppTextField(controller: bioC, label: 'Bio (optional)', maxLines: 3),
                const SizedBox(height: 32),
                PrimaryButton(text: 'Next', onPressed: _next),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
