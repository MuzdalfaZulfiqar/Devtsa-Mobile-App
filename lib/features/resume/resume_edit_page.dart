import 'package:flutter/material.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/empty_state.dart';
import '../../state/app_state.dart';
import '../../models/resume.dart';

class ResumeEditPage extends StatefulWidget {
  const ResumeEditPage({super.key});
  @override
  State<ResumeEditPage> createState() => _ResumeEditPageState();
}

class _ResumeEditPageState extends State<ResumeEditPage> {
  final resume = AppState().resume;
  final summaryC = TextEditingController();

  @override
  void initState() {
    super.initState();
    summaryC.text = resume.summary;
  }

  @override
  void dispose() {
    summaryC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Builder'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/resume/preview'),
            child: const Text('Preview'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppTextField(controller: summaryC, label: 'Summary', maxLines: 3),
          const SizedBox(height: 16),

          _SectionHeader(
            'Education',
            onAdd: () {
              setState(
                () => resume.education = [...resume.education, Education()],
              );
            },
          ),
          if (resume.education.isEmpty)
            EmptyState(
              icon: Icons.school,
              title: 'No education yet',
              subtitle: 'Add your first entry.',
              cta: OutlinedButton(
                onPressed: () {
                  setState(
                    () => resume.education = [...resume.education, Education()],
                  );
                },
                child: const Text('Add Education'),
              ),
            ),
          for (int i = 0; i < resume.education.length; i++)
            _EduCard(
              key: ValueKey('edu_$i'),
              onChanged: (e) => resume.education[i] = e,
              onRemove: () => setState(() => resume.education.removeAt(i)),
            ),

          const SizedBox(height: 16),
          _SectionHeader(
            'Experience',
            onAdd: () {
              setState(
                () => resume.experience = [...resume.experience, Experience()],
              );
            },
          ),
          if (resume.experience.isEmpty)
            const EmptyState(
              icon: Icons.work,
              title: 'No experience yet',
              subtitle: 'Add your first role.',
            ),
          for (int i = 0; i < resume.experience.length; i++)
            _ExpCard(
              key: ValueKey('exp_$i'),
              onChanged: (x) => resume.experience[i] = x,
              onRemove: () => setState(() => resume.experience.removeAt(i)),
            ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Text('Skills: ${resume.skills.join(", ")}')),
              OutlinedButton(
                onPressed: () => setState(
                  () => resume.skills = [...AppState().profile.skills],
                ),
                child: const Text('Import from Profile'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Save (in-memory)',
            onPressed: () {
              resume.summary = summaryC.text.trim();
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;
  const _SectionHeader(this.title, {required this.onAdd});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleMedium),
      IconButton(onPressed: onAdd, icon: const Icon(Icons.add)),
    ],
  );
}

class _EduCard extends StatefulWidget {
  final ValueChanged<Education> onChanged;
  final VoidCallback onRemove;
  const _EduCard({required this.onChanged, required this.onRemove, super.key});
  @override
  State<_EduCard> createState() => _EduCardState();
}

class _EduCardState extends State<_EduCard> {
  final schoolC = TextEditingController(),
      degreeC = TextEditingController(),
      startC = TextEditingController(),
      endC = TextEditingController();
  void _emit() => widget.onChanged(
    Education(
      school: schoolC.text,
      degree: degreeC.text,
      start: startC.text,
      end: endC.text,
    ),
  );

  @override
  void initState() {
    super.initState();
    for (final c in [schoolC, degreeC, startC, endC]) {
      c.addListener(_emit);
    }
  }

  @override
  void dispose() {
    for (final c in [schoolC, degreeC, startC, endC]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            AppTextField(controller: degreeC, label: 'Degree'),
            const SizedBox(height: 8),
            AppTextField(controller: schoolC, label: 'School'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: startC,
                    label: 'Start (YYYY)',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppTextField(controller: endC, label: 'End (YYYY)'),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.onRemove,
                icon: const Icon(Icons.delete),
                label: const Text('Remove'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpCard extends StatefulWidget {
  final ValueChanged<Experience> onChanged;
  final VoidCallback onRemove;
  const _ExpCard({required this.onChanged, required this.onRemove, super.key});
  @override
  State<_ExpCard> createState() => _ExpCardState();
}

class _ExpCardState extends State<_ExpCard> {
  final titleC = TextEditingController(),
      companyC = TextEditingController(),
      startC = TextEditingController(),
      endC = TextEditingController(),
      bulletC = TextEditingController();
  List<String> bullets = [];

  void _emit() => widget.onChanged(
    Experience(
      title: titleC.text,
      company: companyC.text,
      start: startC.text,
      end: endC.text,
      bullets: bullets,
    ),
  );

  @override
  void initState() {
    super.initState();
    for (final c in [titleC, companyC, startC, endC]) {
      c.addListener(_emit);
    }
  }

  @override
  void dispose() {
    for (final c in [titleC, companyC, startC, endC, bulletC]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            AppTextField(controller: titleC, label: 'Title'),
            const SizedBox(height: 8),
            AppTextField(controller: companyC, label: 'Company'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: startC,
                    label: 'Start (YYYY)',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppTextField(controller: endC, label: 'End (YYYY)'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppTextField(controller: bulletC, label: 'Add bullet'),
                ),
                IconButton(
                  onPressed: () {
                    final v = bulletC.text.trim();
                    if (v.isEmpty) return;
                    setState(() {
                      bullets = [...bullets, v];
                      bulletC.clear();
                      _emit();
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: bullets.map((b) => Chip(label: Text(b))).toList(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.onRemove,
                icon: const Icon(Icons.delete),
                label: const Text('Remove'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
