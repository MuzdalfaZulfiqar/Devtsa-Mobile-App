// import 'package:flutter/material.dart';

// class DashboardCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final VoidCallback? onTap;
//   final bool isCompleted;

//   const DashboardCard({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     this.onTap,
//     this.isCompleted = false, required Color backgroundColor, required Color titleColor, required Color subtitleColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         title: Text(
//           title,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: isCompleted ? Colors.green : Colors.black,
//           ),
//         ),
//         subtitle: Text(subtitle),
//         trailing: isCompleted
//             ? const Icon(Icons.check_circle, color: Colors.green)
//             : const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isCompleted;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? subtitleColor;

  const DashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.isCompleted = false,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: backgroundColor ?? theme.colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                isCompleted ? Icons.check_circle : Icons.info,
                color: isCompleted
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: titleColor ?? theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: subtitleColor ??
                            theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.arrow_forward_ios,
                    size: 16, color: theme.colorScheme.onSurface.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
