import 'package:flutter/material.dart';
import '../../../models/resume.dart';

class TemplateB extends StatelessWidget {
  final Resume resume;
  const TemplateB({super.key, required this.resume});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('PROFILE', style: t.titleLarge),
          const Divider(),
          Text(resume.summary),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('EDUCATION', style: t.titleMedium),
                    const SizedBox(height: 8),
                    ...resume.education.map(
                      (e) => ListTile(
                        title: Text(e.school),
                        subtitle: Text('${e.degree}\n${e.start} – ${e.end}'),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('EXPERIENCE', style: t.titleMedium),
                    const SizedBox(height: 8),
                    ...resume.experience.map(
                      (x) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(x.title),
                            Text(x.company, style: t.bodySmall),
                            Text('${x.start} – ${x.end}', style: t.bodySmall),
                            ...x.bullets.map(
                              (b) => Row(
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              children: resume.skills.map((s) => Chip(label: Text(s))).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
