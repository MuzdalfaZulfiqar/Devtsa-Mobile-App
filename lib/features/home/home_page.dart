import 'package:flutter/material.dart';
import '../../state/app_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final profile = AppState().profile;
    final display = profile.displayName.isEmpty
        ? profile.email
        : profile.displayName;
    final c = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'profile', child: Text('Profile')),
              PopupMenuItem(value: 'signout', child: Text('Sign out')),
            ],
            onSelected: (v) {
              if (v == 'profile') {
                Navigator.pushNamed(context, '/profile');
              }
              if (v == 'signout') {
                AppState().signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $display',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _NavCard(
                  icon: Icons.person,
                  title: 'Profile',
                  color: c.primaryContainer,
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
                _NavCard(
                  icon: Icons.article,
                  title: 'Resume Builder',
                  color: c.primaryContainer,
                  onTap: () => Navigator.pushNamed(context, '/resume/edit'),
                ),
                _NavCard(
                  icon: Icons.visibility,
                  title: 'Preview',
                  color: c.primaryContainer,
                  onTap: () => Navigator.pushNamed(context, '/resume/preview'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;
  const _NavCard({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    final on = Theme.of(context).colorScheme.onPrimaryContainer;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 170,
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: on),
              const SizedBox(height: 8),
              Text(title, style: TextStyle(color: on)),
            ],
          ),
        ),
      ),
    );
  }
}
