import 'package:flutter/material.dart';
import '../../../models/resume.dart';
import '../../state/app_state.dart';

class TemplateB extends StatelessWidget {
  final Resume resume;
  const TemplateB({super.key, required this.resume});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header ---
        Center(
          child: Column(
            children: [
              Text(AppState().profile.displayName, style: t.headlineMedium),
              const SizedBox(height: 4),
              Text(
                '${AppState().profile.email} | ${AppState().profile.phone} | ${AppState().profile.linkedin}',
                style: t.bodySmall?.copyWith(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        const Divider(height: 32, thickness: 2),

        // --- Profile Summary ---
        Text('Profile', style: t.titleMedium),
        const SizedBox(height: 8),
        Text(resume.summary, style: t.bodyMedium),
        const SizedBox(height: 24),

        // --- Two Columns: Education | Experience ---
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column: Education
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Education', style: t.titleMedium),
                  const SizedBox(height: 8),
                  ...resume.education.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.school, style: t.bodyLarge),
                          Text('${e.degree} | ${e.start} – ${e.end}', style: t.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 32),

            // Right column: Experience
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Experience', style: t.titleMedium),
                  const SizedBox(height: 8),
                  ...resume.experience.map(
                    (x) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${x.title}', style: t.bodyLarge),
                          Text(x.company, style: t.bodySmall),
                          Text('${x.start} – ${x.end}', style: t.bodySmall),
                          const SizedBox(height: 4),
                          ...x.bullets.map(
                            (b) => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(fontSize: 14)),
                                Expanded(child: Text(b, style: t.bodyMedium)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // --- Skills ---
        if (resume.skills.isNotEmpty) ...[
          Text('Skills', style: t.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: resume.skills
                .map((s) => Chip(
                      label: Text(s),
                      backgroundColor: Colors.teal.withOpacity(0.15),
                      labelStyle: const TextStyle(color: Colors.teal),
                    ))
                .toList(),
          ),
        ],

        // --- Projects ---
        if (resume.projects.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Projects', style: t.titleMedium),
          const SizedBox(height: 8),
          ...resume.projects.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name, style: t.bodyLarge),
                  Text(p.description, style: t.bodyMedium),
                  if (p.link.isNotEmpty) Text(p.link, style: t.bodySmall?.copyWith(color: Colors.blue)),
                ],
              ),
            ),
          ),
        ],

        // --- Certifications ---
        if (resume.certifications.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Certifications', style: t.titleMedium),
          const SizedBox(height: 8),
          ...resume.certifications.map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.title, style: t.bodyLarge),
                  Text('${c.organization} | ${c.year}', style: t.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

