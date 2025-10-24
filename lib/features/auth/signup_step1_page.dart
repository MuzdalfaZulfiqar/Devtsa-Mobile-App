import 'package:flutter/material.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../state/app_state.dart';
import '../../models/user_profile.dart';

class SignUpStep1Page extends StatefulWidget {
  const SignUpStep1Page({super.key});
  @override
  State<SignUpStep1Page> createState() => _SignUpStep1PageState();
}

class _SignUpStep1PageState extends State<SignUpStep1Page> {
  final nameC = TextEditingController();
  final usernameC = TextEditingController();
  final bioC = TextEditingController();
  String? country;

  final countries = const [
    'Pakistan',
    'Saudi Arabia',
    'United Kingdom',
    'United States',
    'France',
  ];

  @override
  void dispose() {
    nameC.dispose();
    usernameC.dispose();
    bioC.dispose();
    super.dispose();
  }

  void _next() {
    final name = nameC.text.trim();
    final username = usernameC.text.trim();
    final selectedCountry = country;
    final bio = bioC.text.trim();

    if (name.isEmpty) {
      _toast('Please enter your name');
      return;
    }
    if (username.isEmpty) {
      _toast('Please choose a username');
      return;
    }
    // Basic username pattern: letters, numbers, underscore, dot; 3–20 chars; no spaces
    final usernameOk = RegExp(r'^[a-zA-Z0-9_\.]{3,20}$').hasMatch(username);
    if (!usernameOk) {
      _toast('Username must be 3–20 chars (letters, numbers, _ or .)');
      return;
    }
    if (selectedCountry == null || selectedCountry.isEmpty) {
      _toast('Please select a country');
      return;
    }

    // Optional: simple uniqueness check against the single in-memory account
    final existing = AppState().registered;
    if (existing != null &&
        existing.username.toLowerCase() == username.toLowerCase()) {
      _toast('That username is already taken');
      return;
    }

    // Build partial profile and pass forward as route argument
    final partial = UserProfile(
      displayName: _titleCase(name),
      username: username.toLowerCase(),
      country: selectedCountry,
      bio: bio,
      email: '', // can be added later in Profile
    );

    Navigator.pushNamed(
      context,
      '/signup/step2',
      arguments: partial, // <-- fixed
    );
  }

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // Nice touch: Title-Case the name
  String _titleCase(String input) {
    return input
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + (w.length > 1 ? w.substring(1).toLowerCase() : ''))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Create account — Step 1 of 2')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Basic info', style: t.titleMedium),
          const SizedBox(height: 12),

          // Full name
          AppTextField(
            controller: nameC,
            label: 'Full name',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 12),

          // Username
          AppTextField(
            controller: usernameC,
            label: 'Username',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 12),

          // Country
          DropdownButtonFormField<String>(
            value: country,
            decoration: const InputDecoration(
              labelText: 'Country',
              border: OutlineInputBorder(),
            ),
            items: countries
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => country = v),
          ),
          const SizedBox(height: 12),

          // Bio
          AppTextField(controller: bioC, label: 'Bio (optional)', maxLines: 3),

          const SizedBox(height: 20),
          PrimaryButton(text: 'Next', onPressed: _next),
        ],
      ),
    );
  }
}
