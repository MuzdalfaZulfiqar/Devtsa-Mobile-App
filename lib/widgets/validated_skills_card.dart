
// import 'package:flutter/material.dart';

// class ValidatedSkillsCard extends StatelessWidget {
//   final List<String> skills;

//   const ValidatedSkillsCard({super.key, required this.skills});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surfaceVariant, // dashboard card vibe
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: theme.colorScheme.shadow.withOpacity(0.05),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.check_circle_outline,
//                   color: theme.colorScheme.primary, size: 24),
//               const SizedBox(width: 8),
//               Text(
//                 "Validated Skills",
//                 style: theme.textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.w600,
//                   color: theme.colorScheme.onSurface,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Wrap(
//             spacing: 8,
//             runSpacing: 6,
//             children: skills
//                 .map((skill) => Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: theme.colorScheme.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         skill,
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           color: theme.colorScheme.primary,
//                         ),
//                       ),
//                     ))
//                 .toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';

class ValidatedSkillsCard extends StatelessWidget {
  final Map<String, double> validatedSkills;
  final double profileScore;
  final bool isValidating;
  final VoidCallback? onValidate;

  const ValidatedSkillsCard({
    super.key,
    required this.validatedSkills,
    required this.profileScore,
    this.onValidate,
    this.isValidating = false,
  });

  String getBarOpacity(double score) {
    if (score >= 0.8) return "opacity-100";
    if (score >= 0.5) return "opacity-80";
    return "opacity-60";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (validatedSkills.isEmpty) {
      return Text(
        "No validated skills yet. Run validation to see confidence scores.",
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      );
    }

    return Container(
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
            "Validated Skills",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...validatedSkills.entries.map((e) {
            final skill = e.key;
            final score = e.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(skill, style: theme.textTheme.bodyMedium),
                    Text("${(score * 100).round()}%", style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: score,
                  backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                  color: theme.colorScheme.primary,
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
              ],
            );
          }).toList(),
          const SizedBox(height: 12),
          Text(
            "Overall Profile Score: $profileScore/100",
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          
        ],
      ),
    );
  }
}
