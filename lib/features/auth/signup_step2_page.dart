import 'package:flutter/material.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/skill_chip.dart';
import '../../state/app_state.dart';
import '../../models/user_profile.dart';

class SignUpStep2Page extends StatefulWidget {
  const SignUpStep2Page({super.key});
  @override
  State<SignUpStep2Page> createState() => _SignUpStep2PageState();
}

class _SignUpStep2PageState extends State<SignUpStep2Page> {
  final skillC = TextEditingController();
  final interestC = TextEditingController();
  List<String> skills = [];
  List<String> interests = [];

  @override
  void dispose() {
    skillC.dispose();
    interestC.dispose();
    super.dispose();
  }

  void _finish(UserProfile base) {
    if (skills.isEmpty) {
      _toast('Add at least one skill');
      return;
    }
    if (interests.isEmpty) {
      _toast('Add at least one interest');
      return;
    }

    final profile = UserProfile(
      displayName: base.displayName,
      username: base.username,
      email: base.email, // can be edited later in Profile
      country: base.country,
      bio: base.bio,
      skills: skills,
      interests: interests,
      githubUrl: '',
      resumeLabel: null,
    );

    final app = AppState();
    // Simple uniqueness guard for username
    if (app.registered != null &&
        app.registered!.username.toLowerCase() ==
            profile.username.toLowerCase()) {
      _toast('Username already exists. Please go back and choose another.');
      return;
    }

    app.register(profile);
    _toast('Account created! You can now log in with your username.');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    // 🔒 Safe cast: returns null if absent or wrong type
    final base = ModalRoute.of(context)?.settings.arguments as UserProfile?;

    // If no valid arguments (e.g., hot restart / deep link), go back to Step 1.
    if (base == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/signup/step1');
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Create account — Step 2 of 2')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Skills & interests', style: t.titleMedium),
          const SizedBox(height: 12),

          // Skills
          Text('Skills', style: t.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in skills)
                SkillChip(
                  label: s,
                  onDeleted: () => setState(() => skills.remove(s)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppTextField(controller: skillC, label: 'Add a skill'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  final v = skillC.text.trim();
                  if (v.isEmpty) return;
                  setState(() {
                    skills = [...skills, v];
                    skillC.clear();
                  });
                },
                child: const Text('Add'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Interests
          Text('Interests', style: t.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in interests)
                SkillChip(
                  label: s,
                  onDeleted: () => setState(() => interests.remove(s)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: interestC,
                  label: 'Add an interest',
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  final v = interestC.text.trim();
                  if (v.isEmpty) return;
                  setState(() {
                    interests = [...interests, v];
                    interestC.clear();
                  });
                },
                child: const Text('Add'),
              ),
            ],
          ),

          const SizedBox(height: 24),
          PrimaryButton(text: 'Create Account', onPressed: () => _finish(base)),
        ],
      ),
    );
  }
}
