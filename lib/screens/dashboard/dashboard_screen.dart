// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../providers/auth_providers.dart';
// import '../../widgets/dashboard_card.dart';
// import '../../widgets/github_card.dart';
// import '../../widgets/validated_skills_card.dart';
// import '../../widgets/info_modal.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   bool showInfoModal = false;
//   String infoTitle = '';
//   String infoMessage = '';

//   void openInfo(String title, String message) {
//     if (!mounted) return; // avoid calling setState on disposed widget
//     setState(() {
//       infoTitle = title;
//       infoMessage = message;
//       showInfoModal = true;
//     });
//   }

//   void closeInfo() {
//     if (!mounted) return;
//     setState(() {
//       showInfoModal = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final user = authProvider.user;

//     // Always wrap loading or empty states in Scaffold
//     if (authProvider.initializing || authProvider.loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (user == null) {
//       return const Scaffold(
//         body: Center(child: Text("No user data available.")),
//       );
//     }

//     final validatedSkillsList = user.validatedSkills?.keys.toList() ?? [];

//     // To-Do Cards
//     final List<Map<String, dynamic>> todoCards = [
//       if (!user.githubConnected)
//         {
//           "title": "Connect GitHub",
//           "subtitle": "Connect your GitHub account to see contributions",
//           "action": () =>
//               openInfo("GitHub Connect", "This will open GitHub authorization"),
//         },
//       if ((user.resumeUrl ?? '').isEmpty)
//         {
//           "title": "Upload Resume",
//           "subtitle": "Upload your resume to improve job matches",
//           "action": () =>
//               openInfo("Resume Upload", "This will open resume upload modal"),
//         },
//       if (!user.skillsValidated)
//         {
//           "title": "Validate Skills",
//           "subtitle": "Validate your skills to unlock achievements",
//           "action": () =>
//               openInfo("Validate Skills", "This will trigger skill validation"),
//         },
//     ];

//     // Completed / Achievements Cards
//     final List<Map<String, dynamic>> completedCards = [
//       if (user.skillsValidated)
//         {
//           "title": "Skills Validated",
//           "subtitle": "Your skills are verified and up-to-date",
//         },
//       if (user.githubConnected)
//         {
//           "title": "GitHub Connected",
//           "subtitle": "Your contributions are now tracked",
//         },
//       if ((user.resumeUrl ?? '').isNotEmpty)
//         {
//           "title": "Resume Uploaded",
//           "subtitle": "Your resume is ready for recruiters",
//         },
//     ];

//     return Scaffold(
//       appBar: AppBar(title: const Text("Dashboard")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Welcome, ${user.name ?? 'Developer'}!",
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const SizedBox(height: 16),

//             // To-Do Cards
//             if (todoCards.isNotEmpty)
//               Column(
//                 children: todoCards
//                     .map((card) => DashboardCard(
//                           title: card['title'],
//                           subtitle: card['subtitle'],
//                           onTap: card['action'],
//                         ))
//                     .toList(),
//               ),

//             const SizedBox(height: 16),

//             // Completed / Achievements
//             if (completedCards.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Achievements",
//                       style: Theme.of(context).textTheme.titleMedium),
//                   const SizedBox(height: 8),
//                   Column(
//                     children: completedCards
//                         .map((card) => DashboardCard(
//                               title: card['title'],
//                               subtitle: card['subtitle'],
//                               isCompleted: true,
//                             ))
//                         .toList(),
//                   ),
//                 ],
//               ),

//             const SizedBox(height: 16),

//             // GitHub Card
//             if (user.githubConnected)
//               GitHubCard(
//                 username: user.githubProfile?['login'] ?? '',
//                 contributions: user.githubStats?['totalRepos'] ?? 0,
//               ),

//             const SizedBox(height: 16),

//             // Validated Skills
//             if (user.skillsValidated || validatedSkillsList.isNotEmpty)
//               ValidatedSkillsCard(skills: validatedSkillsList),
//           ],
//         ),
//       ),

//       // Info Modal
//       floatingActionButton: showInfoModal
//           ? InfoModal(
//               title: infoTitle,
//               message: infoMessage,
//               onClose: closeInfo,
//             )
//           : null,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_providers.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/github_card.dart';
import '../../widgets/validated_skills_card.dart';
import '../../widgets/info_modal.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool showInfoModal = false;
  String infoTitle = '';
  String infoMessage = '';

  void openInfo(String title, String message) {
    if (!mounted) return;
    setState(() {
      infoTitle = title;
      infoMessage = message;
      showInfoModal = true;
    });
  }

  void closeInfo() {
    if (!mounted) return;
    setState(() {
      showInfoModal = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // Loading state
    if (authProvider.initializing || authProvider.loading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    // No user
    if (user == null) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: Text(
            "No user data available.",
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    final validatedSkillsList = user.validatedSkills?.keys.toList() ?? [];

    // To-Do Cards
    final List<Map<String, dynamic>> todoCards = [
      if (!user.githubConnected)
        {
          "title": "Connect GitHub",
          "subtitle": "Connect your GitHub account to see contributions",
          "action": () =>
              openInfo("GitHub Connect", "This will open GitHub authorization"),
        },
      if ((user.resumeUrl ?? '').isEmpty)
        {
          "title": "Upload Resume",
          "subtitle": "Upload your resume to improve job matches",
          "action": () =>
              openInfo("Resume Upload", "This will open resume upload modal"),
        },
      if (!user.skillsValidated)
        {
          "title": "Validate Skills",
          "subtitle": "Validate your skills to unlock achievements",
          "action": () =>
              openInfo("Validate Skills", "This will trigger skill validation"),
        },
    ];

    // Completed / Achievements Cards
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

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text("Dashboard", style: theme.appBarTheme.titleTextStyle),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              "Welcome, ${user.name ?? 'Developer'}!",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),

            // To-Do Cards
            if (todoCards.isNotEmpty)
              Column(
                children: todoCards
                    .map((card) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: DashboardCard(
                            title: card['title'],
                            subtitle: card['subtitle'],
                            onTap: card['action'],
                            backgroundColor: theme.colorScheme.secondaryContainer,
                            titleColor: theme.colorScheme.onSecondaryContainer,
                            subtitleColor: theme.colorScheme.onSecondaryContainer.withOpacity(0.8),
                          ),
                        ))
                    .toList(),
              ),

            const SizedBox(height: 24),

            // Completed / Achievements
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
                    children: completedCards
                        .map((card) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: DashboardCard(
                                title: card['title'],
                                subtitle: card['subtitle'],
                                isCompleted: true,
                                backgroundColor: theme.colorScheme.surfaceVariant,
                                titleColor: theme.colorScheme.onSurfaceVariant,
                                subtitleColor: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // GitHub Card
            if (user.githubConnected)
              GitHubCard(
                username: user.githubProfile?['login'] ?? '',
                contributions: user.githubStats?['totalRepos'] ?? 0,
              ),

            const SizedBox(height: 24),

            // Validated Skills
            if (user.skillsValidated || validatedSkillsList.isNotEmpty)
              ValidatedSkillsCard(skills: validatedSkillsList),
          ],
        ),
      ),

      // Info Modal
      floatingActionButton: showInfoModal
          ? InfoModal(
              title: infoTitle,
              message: infoMessage,
              onClose: closeInfo,
            )
          : null,
    );
  }
}
