import 'package:flutter/material.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/skill_chip.dart';
import '../../widgets/primary_button.dart';
import '../../state/app_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final profile = AppState().profile;
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final bioC = TextEditingController();
  final githubC = TextEditingController();
  final skillC = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameC.text = profile.displayName;
    emailC.text = profile.email;
    bioC.text = profile.bio;
    githubC.text = profile.githubUrl;
  }

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    bioC.dispose();
    githubC.dispose();
    skillC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('General', style: t.titleMedium),
          const SizedBox(height: 8),
          AppTextField(controller: nameC, label: 'Name'),
          const SizedBox(height: 12),
          AppTextField(
            controller: emailC,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: githubC,
            label: 'GitHub URL',
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 12),
          AppTextField(controller: bioC, label: 'Bio', maxLines: 3),
          const SizedBox(height: 16),
          Text('Skills', style: t.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in profile.skills)
                SkillChip(
                  label: s,
                  onDeleted: () {
                    setState(() => profile.skills.remove(s));
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppTextField(controller: skillC, label: 'Add skill'),
              ),
              const SizedBox(width: 8),
              PrimaryButton(
                text: 'Add',
                onPressed: () {
                  final v = skillC.text.trim();
                  if (v.isEmpty) return;
                  setState(() => profile.skills = [...profile.skills, v]);
                  skillC.clear();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Text('Resume: ${profile.resumeLabel ?? "None"}')),
              OutlinedButton(
                onPressed: () {
                  setState(
                    () => profile.resumeLabel = 'resume.pdf',
                  ); // visual only
                },
                child: const Text('Set Label'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Save (in-memory)',
            onPressed: () {
              profile
                ..displayName = nameC.text.trim()
                ..email = emailC.text.trim()
                ..githubUrl = githubC.text.trim()
                ..bio = bioC.text.trim();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved for this session.')),
              );
            },
          ),
        ],
      ),
    );
  }
}
