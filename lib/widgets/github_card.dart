// import 'package:flutter/material.dart';

// class GitHubCard extends StatelessWidget {
//   final String username;
//   final int contributions;

//   const GitHubCard({
//     super.key,
//     required this.username,
//     required this.contributions,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         leading: const Icon(Icons.code),
//         title: Text(username),
//         subtitle: Text('$contributions contributions this year'),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class GitHubCard extends StatelessWidget {
  final String username;
  final int contributions;

  const GitHubCard({
    super.key,
    required this.username,
    required this.contributions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "GitHub Profile",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            username,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "$contributions contributions",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSecondaryContainer.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

