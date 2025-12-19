import 'package:flutter/material.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/skill_chip.dart';
import '../../widgets/primary_button.dart';
import '../../state/app_state.dart';
import '../../widgets/app_bar_with_border.dart';

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

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: appBarWithBorder(
  'My Profile',
  actions: [
    IconButton(
      icon: const Icon(Icons.public),
      onPressed: () => Navigator.pushNamed(context, '/profile/public'),
    ),
  ],
),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF008080),
              child: Text(
                profile.displayName.isNotEmpty
                    ? profile.displayName[0].toUpperCase()
                    : 'U',
                style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: c.onPrimaryContainer),
              ),
            ),
          ),

          sectionTitle('General Information'),
          AppTextField(controller: nameC, label: 'Full Name'),
          const SizedBox(height: 12),
          AppTextField(controller: emailC, label: 'Email'),
          const SizedBox(height: 12),
          AppTextField(controller: githubC, label: 'GitHub URL'),
          const SizedBox(height: 12),
          AppTextField(controller: bioC, label: 'Bio', maxLines: 3),

          sectionTitle('Skills'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in profile.skills)
                SkillChip(
                  label: s,
                  onDeleted: () =>
                      setState(() => profile.skills.remove(s)),
                ),
            ],
          ),
          const SizedBox(height: 10),
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

          // sectionTitle('Resume'),
          Row(
            children: [
              Expanded(
                child: Text(profile.resumeLabel ?? 'No Resume Linked'),
              ),
              OutlinedButton(
                onPressed: () =>
                    setState(() => profile.resumeLabel = 'resume.pdf'),
                child: const Text('Add Label'),
              )
            ],
          ),

          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Save',
            onPressed: () {
              profile
                ..displayName = nameC.text.trim()
                ..email = emailC.text.trim()
                ..githubUrl = githubC.text.trim()
                ..bio = bioC.text.trim();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile saved for this session.'),
                ),
              );
            },
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}
