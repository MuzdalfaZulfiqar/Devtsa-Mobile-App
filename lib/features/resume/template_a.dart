import 'package:flutter/material.dart';
import '../../../models/resume.dart';
import '../../state/app_state.dart';


class TemplateA extends StatelessWidget {
  final Resume resume;
  const TemplateA({super.key, required this.resume});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header: Name & Contact ---
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

        // --- Summary ---
        Text('Summary', style: t.titleMedium),
        const SizedBox(height: 8),
        Text(resume.summary, style: t.bodyMedium),
        const SizedBox(height: 24),

        // --- Education ---
        Text('Education', style: t.titleMedium),
        const SizedBox(height: 8),
        ...resume.education.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${e.degree} — ${e.school}', style: t.bodyLarge),
                Text('${e.start} – ${e.end}', style: t.bodySmall),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // --- Experience ---
        Text('Experience', style: t.titleMedium),
        const SizedBox(height: 8),
        ...resume.experience.map(
          (x) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${x.title} — ${x.company}', style: t.bodyLarge),
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
        const SizedBox(height: 24),

        // --- Projects ---
        if (resume.projects.isNotEmpty) ...[
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
          const SizedBox(height: 24),
        ],

        // --- Certifications ---
        if (resume.certifications.isNotEmpty) ...[
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
          const SizedBox(height: 24),
        ],

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
      ],
    );
  }
}
