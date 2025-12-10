

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_providers.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/github_connect_modal.dart';
import '../../widgets/resume_upload_modal.dart';
import '../../widgets/validated_skills_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String BACKEND_URL = "https://devsta-backend.onrender.com";

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool openGithubModal = false;
  bool openResumeModal = false;
  bool isValidating = false;

Future<void> runValidation() async {
  final auth = Provider.of<AuthProvider>(context, listen: false);

  try {
    setState(() => isValidating = true);

    // Call the provider method to validate skills
    await auth.validateSkills();

  } catch (e) {
    debugPrint("Validation error: $e");
  } finally {
    if (mounted) setState(() => isValidating = false);
  }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (authProvider.initializing || authProvider.loading) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    }

    if (user == null) {
      return Center(
        child: Text(
          "No user data available.",
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      );
    }

    final validatedSkills = user.validatedSkills ?? {};

    final List<Map<String, dynamic>> todoCards = [
      if (!user.githubConnected)
        {
          "title": "Connect GitHub",
          "subtitle": "Connect your GitHub account to see contributions",
          "action": () => setState(() => openGithubModal = true),
        },
      if ((user.resumeUrl ?? '').isEmpty)
        {
          "title": "Upload Resume",
          "subtitle": "Upload your resume to improve job matches",
          "action": () => setState(() => openResumeModal = true),
        },
      if (!user.skillsValidated)
        {
          "title": "Validate Skills",
          "subtitle": "Validate your skills to unlock achievements",
          "action": runValidation,
        },
    ];

    final List<Map<String, dynamic>> completedCards = [
      if (user.skillsValidated)
        {
          "title": "Skills Validated",
          "subtitle": "Your skills are verified and up-to-date",
        },
      if (user.githubConnected)
        {
          "title": "GitHub Connected",
          "subtitle": "Your contributions are now tracked",
        },
      if ((user.resumeUrl ?? '').isNotEmpty)
        {
          "title": "Resume Uploaded",
          "subtitle": "Your resume is ready for recruiters",
        },
    ];

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, ${user.name ?? 'Developer'}!",
                style: theme.textTheme.headlineSmall
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 20),

              // Top Skills (always visible)
              if (user.topSkills != null && user.topSkills!.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Top Skills",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: user.topSkills!.map((skill) {
                          return Chip(
                            label: Text(skill),
                            backgroundColor: theme.colorScheme.secondaryContainer,
                            labelStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),

              // TODO Cards
              if (todoCards.isNotEmpty)
                Column(
                  children: todoCards.map((card) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: DashboardCard(
                        title: card['title'],
                        subtitle: card['subtitle'],
                        onTap: card['action'],
                        backgroundColor: theme.colorScheme.secondaryContainer,
                        titleColor: theme.colorScheme.onSecondaryContainer,
                        subtitleColor: theme.colorScheme.onSecondaryContainer
                            .withOpacity(0.8),
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 24),

              // Achievements
              if (completedCards.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Achievements",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: completedCards.map((card) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: DashboardCard(
                            title: card['title'],
                            subtitle: card['subtitle'],
                            isCompleted: true,
                            backgroundColor: theme.colorScheme.surfaceVariant,
                            titleColor: theme.colorScheme.onSurfaceVariant,
                            subtitleColor: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.7),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

              const SizedBox(height: 24),

              // Validated Skills Card
              ValidatedSkillsCard(
                validatedSkills: validatedSkills,
                profileScore: user.profileScore ?? 0,
                isValidating: isValidating,
                onValidate: runValidation,
              ),
            ],
          ),
        ),

        // Resume Modal
        if (openResumeModal)
          ResumeUploadModal(
            open: true,
            onClose: () => setState(() => openResumeModal = false),
          ),

        // GitHub Modal
        if (openGithubModal)
          GitHubConnectModal(
            open: true,
            onClose: () => setState(() => openGithubModal = false),
          ),
      ],
    );
  }
}
