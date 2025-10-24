import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../widgets/app_bar_with_border.dart';

class PublicProfilePage extends StatelessWidget {
  const PublicProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = AppState().profile;
    final c = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: c.surface,
      appBar: appBarWithBorder("Profile"),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          // --- Header (No border, centered) ---
          Column(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: const Color(0xFF008080), // Teal
                child: Text(
                  profile.displayName.isNotEmpty
                      ? profile.displayName[0].toUpperCase()
                      : 'U',
                  style: textTheme.headlineSmall?.copyWith(
                    color: c.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                profile.displayName,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // --- Bio Section ---
          _title("Bio", context),
          _section(
            context,
            child: Text(
              profile.bio.isEmpty ? "No bio added yet" : profile.bio,
              style: textTheme.bodyMedium?.copyWith(color: c.onSurfaceVariant),
              textAlign: TextAlign.justify,
            ),
          ),

          const SizedBox(height: 24),

          // --- General Info Section ---
          _title("General Information", context),
          _section(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(Icons.email, profile.email),
                if (profile.githubUrl.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _infoRow(Icons.code, profile.githubUrl),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- Skills Section ---
          _title("Skills", context),
          _section(
            context,
            child: profile.skills.isEmpty
                ? const Text("No skills added yet")
                : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final s in profile.skills)
                        Chip(
                          label: Text(s),
                          backgroundColor:
                              const Color(0xFF008080).withOpacity(0.15),
                          labelStyle: TextStyle(
                            color: const Color(0xFF008080),
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _title(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _section(BuildContext context, {required Widget child}) {
    final c = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.outlineVariant.withOpacity(0.6)),
      ),
      child: child,
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF008080)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text.isEmpty ? "Not provided" : text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
