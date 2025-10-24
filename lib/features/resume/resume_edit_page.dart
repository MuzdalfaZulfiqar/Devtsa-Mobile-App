import 'package:flutter/material.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/empty_state.dart';
import '../../state/app_state.dart';
import '../../models/resume.dart';
import '../../widgets/app_bar_with_border.dart';

class ResumeEditPage extends StatefulWidget {
  const ResumeEditPage({super.key});
  @override
  State<ResumeEditPage> createState() => _ResumeEditPageState();
}

class _ResumeEditPageState extends State<ResumeEditPage> {
 late Resume resume; // changed from final resume = AppState().resume;
  final summaryC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final linkedinC = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize resume safely
    resume = AppState().resume ?? Resume();

    // Ensure all lists are not null
    resume.education = resume.education ?? [];
    resume.experience = resume.experience ?? [];
    resume.projects = resume.projects ?? [];
    resume.certifications = resume.certifications ?? [];
    resume.skills = resume.skills ?? [];

    // Initialize controllers
    summaryC.text = resume.summary;
    emailC.text = AppState().profile.email;
    phoneC.text = AppState().profile.phone ?? '';
    linkedinC.text = AppState().profile.linkedin ?? '';
  }

  @override
  void dispose() {
    summaryC.dispose();
    emailC.dispose();
    phoneC.dispose();
    linkedinC.dispose();
    super.dispose();
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: appBarWithBorder(
        'Resume Builder',
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/resume/preview'),
            child: const Text(
              'Preview',
              style: TextStyle(color: Color(0xFF008080)),
            ),
          ),
        ],
      ),
    body: ListView(
  padding: const EdgeInsets.all(16),
  children: [
    // --- Contact Info ---
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF008080).withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle('Contact Info'),
            const SizedBox(height: 8),
            AppTextField(controller: emailC, label: 'Email'),
            const SizedBox(height: 12),
            AppTextField(controller: phoneC, label: 'Phone'),
            const SizedBox(height: 12),
            AppTextField(controller: linkedinC, label: 'LinkedIn / Portfolio URL'),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),

    // --- Summary ---
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF008080).withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle('Summary'),
            const SizedBox(height: 8),
            AppTextField(controller: summaryC, label: 'Summary', maxLines: 3),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),

    // --- Education ---
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF008080).withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            _SectionHeader(
              'Education',
              onAdd: () => setState(() => resume.education = [...resume.education, Education()]),
            ),
            const SizedBox(height: 8),
            if (resume.education.isEmpty)
              EmptyState(
                icon: Icons.school,
                title: 'No education yet',
                subtitle: 'Add your first entry.',
                cta: OutlinedButton(
                  onPressed: () => setState(() => resume.education = [...resume.education, Education()]),
                  child: const Text('Add Education'),
                ),
              ),
            for (int i = 0; i < resume.education.length; i++) ...[
              _EduCard(
                key: ValueKey('edu_$i'),
                onChanged: (e) => resume.education[i] = e,
                onRemove: () => setState(() => resume.education.removeAt(i)),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    ),

    // --- Experience ---
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF008080).withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            _SectionHeader(
              'Experience',
              onAdd: () => setState(() => resume.experience = [...resume.experience, Experience()]),
            ),
            const SizedBox(height: 8),
            if (resume.experience.isEmpty)
              const EmptyState(
                icon: Icons.work,
                title: 'No experience yet',
                subtitle: 'Add your first role.',
              ),
            for (int i = 0; i < resume.experience.length; i++) ...[
              _ExpCard(
                key: ValueKey('exp_$i'),
                onChanged: (x) => resume.experience[i] = x,
                onRemove: () => setState(() => resume.experience.removeAt(i)),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    ),

    // --- Projects ---
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF008080).withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            _SectionHeader(
              'Projects',
              onAdd: () => setState(() => resume.projects = [...resume.projects, Project()]),
            ),
            const SizedBox(height: 8),
            if (resume.projects.isEmpty)
              EmptyState(
                icon: Icons.code,
                title: 'No projects yet',
                subtitle: 'Add your first project.',
                cta: OutlinedButton(
                  onPressed: () => setState(() => resume.projects = [...resume.projects, Project()]),
                  child: const Text('Add Project'),
                ),
              ),
            for (int i = 0; i < resume.projects.length; i++) ...[
              _ProjectCard(
                key: ValueKey('proj_$i'),
                onChanged: (p) => resume.projects[i] = p,
                onRemove: () => setState(() => resume.projects.removeAt(i)),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    ),

    // --- Certifications ---
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF008080).withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            _SectionHeader(
              'Certifications',
              onAdd: () => setState(() => resume.certifications = [...resume.certifications, Certification()]),
            ),
            const SizedBox(height: 8),
            if (resume.certifications.isEmpty)
              EmptyState(
                icon: Icons.card_membership,
                title: 'No certifications yet',
                subtitle: 'Add your first certification.',
                cta: OutlinedButton(
                  onPressed: () => setState(() => resume.certifications = [...resume.certifications, Certification()]),
                  child: const Text('Add Certification'),
                ),
              ),
            for (int i = 0; i < resume.certifications.length; i++) ...[
              _CertCard(
                key: ValueKey('cert_$i'),
                onChanged: (c) => resume.certifications[i] = c,
                onRemove: () => setState(() => resume.certifications.removeAt(i)),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    ),

    // --- Skills ---
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF008080).withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle('Skills'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in resume.skills)
                  Chip(
                    label: Text(s),
                    backgroundColor: const Color(0xFF008080).withOpacity(0.15),
                    labelStyle: const TextStyle(color: Color(0xFF008080)),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => setState(() => resume.skills = [...AppState().profile.skills]),
              child: const Text(
                'Import from Profile',
                style: TextStyle(color: Color(0xFF008080)),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),

    const SizedBox(height: 16),
    PrimaryButton(
      text: 'Save (in-memory)',
      onPressed: () {
        resume.summary = summaryC.text.trim();
        AppState().profile.email = emailC.text.trim();
        AppState().profile.phone = phoneC.text.trim();
        AppState().profile.linkedin = linkedinC.text.trim();

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

// ---------------- Section Header ----------------
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;
  const _SectionHeader(this.title, {required this.onAdd});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          IconButton(onPressed: onAdd, icon: const Icon(Icons.add, color: Color(0xFF008080))),
        ],
      );
}

// ---------------- Education Card ----------------
class _EduCard extends StatefulWidget {
  final ValueChanged<Education> onChanged;
  final VoidCallback onRemove;
  const _EduCard({required this.onChanged, required this.onRemove, super.key});
  @override
  State<_EduCard> createState() => _EduCardState();
}

class _EduCardState extends State<_EduCard> {
  final schoolC = TextEditingController(), degreeC = TextEditingController(), startC = TextEditingController(), endC = TextEditingController();
  void _emit() => widget.onChanged(Education(
        school: schoolC.text,
        degree: degreeC.text,
        start: startC.text,
        end: endC.text,
      ));

  @override
  void initState() {
    super.initState();
    for (final c in [schoolC, degreeC, startC, endC]) c.addListener(_emit);
  }

  @override
  void dispose() {
    for (final c in [schoolC, degreeC, startC, endC]) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
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
                Expanded(child: AppTextField(controller: startC, label: 'Start (YYYY)')),
                const SizedBox(width: 8),
                Expanded(child: AppTextField(controller: endC, label: 'End (YYYY)')),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.onRemove,
                icon: const Icon(Icons.delete, color: Color(0xFF008080)),
                label: const Text('Remove', style: TextStyle(color: Color(0xFF008080))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Experience Card ----------------
class _ExpCard extends StatefulWidget {
  final ValueChanged<Experience> onChanged;
  final VoidCallback onRemove;
  const _ExpCard({required this.onChanged, required this.onRemove, super.key});
  @override
  State<_ExpCard> createState() => _ExpCardState();
}

class _ExpCardState extends State<_ExpCard> {
  final titleC = TextEditingController(), companyC = TextEditingController(), startC = TextEditingController(), endC = TextEditingController(), bulletC = TextEditingController();
  List<String> bullets = [];

  void _emit() => widget.onChanged(Experience(
        title: titleC.text,
        company: companyC.text,
        start: startC.text,
        end: endC.text,
        bullets: bullets,
      ));

  @override
  void initState() {
    super.initState();
    for (final c in [titleC, companyC, startC, endC]) c.addListener(_emit);
  }

  @override
  void dispose() {
    for (final c in [titleC, companyC, startC, endC, bulletC]) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            AppTextField(controller: titleC, label: 'Title / Role'),
            const SizedBox(height: 8),
            AppTextField(controller: companyC, label: 'Company / Organization'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: AppTextField(controller: startC, label: 'Start (YYYY)')),
                const SizedBox(width: 8),
                Expanded(child: AppTextField(controller: endC, label: 'End (YYYY)')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: AppTextField(controller: bulletC, label: 'Add bullet point')),
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
                  icon: const Icon(Icons.add, color: Color(0xFF008080)),
                ),
              ],
            ),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: bullets
                  .map((b) => Chip(
                        label: Text(b),
                        backgroundColor: const Color(0xFF008080).withOpacity(0.15),
                        labelStyle: const TextStyle(color: Color(0xFF008080), fontSize: 12),
                      ))
                  .toList(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.onRemove,
                icon: const Icon(Icons.delete, color: Color(0xFF008080)),
                label: const Text('Remove', style: TextStyle(color: Color(0xFF008080))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Project Card ----------------
class _ProjectCard extends StatefulWidget {
  final ValueChanged<Project> onChanged;
  final VoidCallback onRemove;
  const _ProjectCard({required this.onChanged, required this.onRemove, super.key});
  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  final nameC = TextEditingController(), descC = TextEditingController(), linkC = TextEditingController();

  void _emit() => widget.onChanged(Project(
        name: nameC.text,
        description: descC.text,
        link: linkC.text,
      ));

  @override
  void initState() {
    super.initState();
    for (final c in [nameC, descC, linkC]) c.addListener(_emit);
  }

  @override
  void dispose() {
    for (final c in [nameC, descC, linkC]) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            AppTextField(controller: nameC, label: 'Project Name'),
            const SizedBox(height: 8),
            AppTextField(controller: descC, label: 'Description', maxLines: 2),
            const SizedBox(height: 8),
            AppTextField(controller: linkC, label: 'Project Link (Optional)'),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.onRemove,
                icon: const Icon(Icons.delete, color: Color(0xFF008080)),
                label: const Text('Remove', style: TextStyle(color: Color(0xFF008080))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Certification Card ----------------
class _CertCard extends StatefulWidget {
  final ValueChanged<Certification> onChanged;
  final VoidCallback onRemove;
  const _CertCard({required this.onChanged, required this.onRemove, super.key});
  @override
  State<_CertCard> createState() => _CertCardState();
}

class _CertCardState extends State<_CertCard> {
  final titleC = TextEditingController(), orgC = TextEditingController(), yearC = TextEditingController();

  void _emit() => widget.onChanged(Certification(
        title: titleC.text,
        organization: orgC.text,
        year: yearC.text,
      ));

  @override
  void initState() {
    super.initState();
    for (final c in [titleC, orgC, yearC]) c.addListener(_emit);
  }

  @override
  void dispose() {
    for (final c in [titleC, orgC, yearC]) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            AppTextField(controller: titleC, label: 'Certification Name'),
            const SizedBox(height: 8),
            AppTextField(controller: orgC, label: 'Issuing Organization'),
            const SizedBox(height: 8),
            AppTextField(controller: yearC, label: 'Year'),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.onRemove,
                icon: const Icon(Icons.delete, color: Color(0xFF008080)),
                label: const Text('Remove', style: TextStyle(color: Color(0xFF008080))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
