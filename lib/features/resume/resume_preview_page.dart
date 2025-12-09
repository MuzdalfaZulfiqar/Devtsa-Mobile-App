import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import 'template_a.dart';
import 'template_b.dart';
import '../../models/resume.dart'; // make sure Resume is imported

class ResumePreviewPage extends StatefulWidget {
  const ResumePreviewPage({super.key});
  @override
  State<ResumePreviewPage> createState() => _ResumePreviewPageState();
}

class _ResumePreviewPageState extends State<ResumePreviewPage> {
  int templateIndex = 0;

  late Resume resume; // declare late

  @override
  void initState() {
    super.initState();

    // Initialize resume safely
    resume = AppState().resume ?? Resume();

    // Ensure all lists are non-null
    resume.education = resume.education ?? [];
    resume.experience = resume.experience ?? [];
    resume.projects = resume.projects ?? [];
    resume.certifications = resume.certifications ?? [];
    resume.skills = resume.skills ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final body = templateIndex == 0
        ? TemplateA(resume: resume)
        : TemplateB(resume: resume);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        actions: [
          DropdownButton<int>(
            value: templateIndex,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 0, child: Text('Template A')),
              DropdownMenuItem(value: 1, child: Text('Template B')),
            ],
            onChanged: (v) {
              setState(() => templateIndex = v ?? 0);
            },
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export disabled in frontend-only demo.'),
                ),
              );
            },
            child: const Text(''),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 800, // standard resume width
            margin: const EdgeInsets.symmetric(vertical: 24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: templateIndex == 0
                ? TemplateA(resume: resume)
                : TemplateB(resume: resume),
          ),
        ),
      ),
    );
  }
}
