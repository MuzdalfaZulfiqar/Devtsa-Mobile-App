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
      backgroundColor: c.surface,
      appBar: PreferredSize(
  preferredSize: const Size.fromHeight(60),
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: c.surface,
      border: Border(
        bottom: BorderSide(color: c.outline.withOpacity(0.1), width: 1.2),
      ),
    ),
    child: Row(
      children: [
        Text(
          'Dashboard',
          style: TextStyle(
            color: c.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        const Spacer(),
        PopupMenuButton(
          color: c.surface,
          icon: Icon(Icons.more_vert, color: c.onSurface),
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
  ),
),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $display',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Good to see you back',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: c.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 26),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 22,
                crossAxisSpacing: 22,
                childAspectRatio: 1.15,
                physics: const BouncingScrollPhysics(),
                children: [
                  _NavCard(
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                  ),
                  _NavCard(
                    icon: Icons.description,
                    title: 'Resume Builder',
                    onTap: () => Navigator.pushNamed(context, '/resume/edit'),
                  ),
                  _NavCard(
                    icon: Icons.visibility,
                    title: 'Preview Resume',
                    onTap: () =>
                        Navigator.pushNamed(context, '/resume/preview'),
                  ),
                  _NavCard(
                    icon: Icons.feed, // changed from star to feed icon
                    title: 'Feed',
                    onTap: () =>
                        Navigator.pushNamed(context, '/feed'), // opens FeedPage
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSkillsDialog(BuildContext context, profile) {
    final c = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Skills & Interests'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (profile.skills.isNotEmpty) ...[
                const Text(
                  'Skills:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: profile.skills
                      .map<Widget>(
                        (s) => Chip(
                          label: Text(s),
                          backgroundColor: c.primary.withOpacity(0.15),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],
              if (profile.interests.isNotEmpty) ...[
                const Text(
                  'Interests:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: profile.interests
                      .map<Widget>(
                        (i) => Chip(
                          label: Text(i),
                          backgroundColor: c.secondary.withOpacity(0.15),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _NavCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              c.surfaceVariant.withOpacity(0.85),
              c.surfaceVariant.withOpacity(0.98),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: c.outline.withOpacity(0.12), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: c.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: c.primary),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: c.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
