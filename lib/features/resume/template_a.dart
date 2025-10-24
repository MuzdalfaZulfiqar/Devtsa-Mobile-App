import 'package:flutter/material.dart';
import '../../../models/resume.dart';

class TemplateA extends StatelessWidget {
  final Resume resume;
  const TemplateA({super.key, required this.resume});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary', style: t.titleMedium),
          const SizedBox(height: 8),
          Text(resume.summary),
          const SizedBox(height: 16),
          Text('Education', style: t.titleMedium),
          ...resume.education.map(
            (e) => ListTile(
              title: Text('${e.degree} — ${e.school}'),
              subtitle: Text('${e.start} – ${e.end}'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 16),
          Text('Experience', style: t.titleMedium),
          ...resume.experience.map(
            (x) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${x.title} — ${x.company}', style: t.bodyLarge),
                  Text('${x.start} – ${x.end}', style: t.bodySmall),
                  ...x.bullets.map(
                    (b) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• '),
                        Expanded(child: Text(b)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: resume.skills.map((s) => Chip(label: Text(s))).toList(),
          ),
        ],
      ),
    );
  }
}
