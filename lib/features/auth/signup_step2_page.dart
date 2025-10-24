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
    if (skills.isEmpty) return _toast('Add at least one skill');
    if (interests.isEmpty) return _toast('Add at least one interest');

    final profile = UserProfile(
      displayName: base.displayName,
      username: base.username,
      password: base.password,
      email: base.email,
      country: base.country,
      bio: base.bio,
      skills: skills,
      interests: interests,
    );

    final app = AppState();
    app.register(profile);
    _toast('Account created! You can now log in with your username.');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final base = args as UserProfile?;
    if (base == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pushReplacementNamed(context, '/signup/step1');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                Text('Step 2 of 2 — Skills & Interests', style: t.headlineSmall),
                const SizedBox(height: 32),

                Text('Skills', style: t.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills.map((s) => SkillChip(label: s, onDeleted: () => setState(() => skills.remove(s)))).toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: AppTextField(controller: skillC, label: 'Add a skill')),
                    const SizedBox(width: 8),
                    FilledButton(onPressed: () {
                      final v = skillC.text.trim();
                      if(v.isEmpty) return;
                      setState((){ skills.add(v); skillC.clear(); });
                    }, child: const Text('Add')),
                  ],
                ),
                const SizedBox(height: 24),

                Text('Interests', style: t.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: interests.map((s) => SkillChip(label: s, onDeleted: () => setState(() => interests.remove(s)))).toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: AppTextField(controller: interestC, label: 'Add an interest')),
                    const SizedBox(width: 8),
                    FilledButton(onPressed: () {
                      final v = interestC.text.trim();
                      if(v.isEmpty) return;
                      setState((){ interests.add(v); interestC.clear(); });
                    }, child: const Text('Add')),
                  ],
                ),
                const SizedBox(height: 32),
                PrimaryButton(text: 'Create Account', onPressed: () => _finish(base)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
