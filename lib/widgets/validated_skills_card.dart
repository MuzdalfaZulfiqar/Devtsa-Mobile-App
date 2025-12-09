// import 'package:flutter/material.dart';

// class ValidatedSkillsCard extends StatelessWidget {
//   final List<String> skills;

//   const ValidatedSkillsCard({super.key, required this.skills});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Validated Skills",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: skills
//                   .map((skill) => Chip(
//                         label: Text(skill),
//                         backgroundColor: Colors.blue.shade100,
//                       ))
//                   .toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ValidatedSkillsCard extends StatelessWidget {
  final List<String> skills;

  const ValidatedSkillsCard({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant, // dashboard card vibe
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline,
                  color: theme.colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                "Validated Skills",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: skills
                .map((skill) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        skill,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
