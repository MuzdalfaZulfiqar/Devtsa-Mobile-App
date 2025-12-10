import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import '../services/api_client.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileOverview extends StatefulWidget {
  final String token;
  const ProfileOverview({super.key, required this.token});

  @override
  State<ProfileOverview> createState() => _ProfileOverviewState();
}

class _ProfileOverviewState extends State<ProfileOverview> {
  DevstaUser? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      final authService = AuthService(ApiClient());
      final u = await authService.getCurrentUser(widget.token);

      if (!mounted) return; // <-- ADD THIS CHECK
      setState(() {
        user = u;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return; // <-- ADD THIS CHECK
      setState(() {
        loading = false;
      });
      debugPrint("Failed to fetch user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (loading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 3));
    }

    if (user == null) {
      return const Center(child: Text("Failed to load profile."));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // YOUR FAVORITE HERO CARD - RESTORED & PERFECTED
          // ONLY THIS PART CHANGED — the rest of the file stays 100% the same as the last version
          // PERFECT FULL-WIDTH HERO CARD (your favorite one, now fixed)
          Card(
            elevation: 12,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 0,
            ), // removes side gaps
            child: Container(
              width: double.infinity, // forces full width
              padding: const EdgeInsets.fromLTRB(32, 36, 32, 36),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withOpacity(0.09),
                    colorScheme.surface.withOpacity(0.95),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user!.email.split('@').first,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (user!.primaryRole.isNotEmpty)
                    Text(
                      user!.primaryRole,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (user!.experienceLevel.isNotEmpty)
                    Text(
                      user!.experienceLevel,
                      style: TextStyle(
                        fontSize: 17,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  const SizedBox(height: 14),
                  Text(
                    user!.email,
                    style: TextStyle(
                      fontSize: 15.5,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36),

          // Clean, minimal sections with perfect spacing
          if (user!.phone.isNotEmpty ||
              user!.experienceLevel.isNotEmpty ||
              user!.primaryRole.isNotEmpty)
            _buildSection(
              icon: Icons.person_outline_rounded,
              title: "General Info",
              children: [
                if (user!.phone.isNotEmpty)
                  _buildInfoRow(Icons.phone_outlined, "Phone", user!.phone!),
                if (user!.experienceLevel.isNotEmpty)
                  _buildInfoRow(
                    Icons.trending_up_rounded,
                    "Experience",
                    user!.experienceLevel,
                  ),
                if (user!.primaryRole.isNotEmpty)
                  _buildInfoRow(
                    Icons.work_outline_rounded,
                    "Role",
                    user!.primaryRole,
                  ),
              ],
            ),

          if (user!.bio != null && user!.bio!.trim().isNotEmpty)
            _buildSection(
              icon: Icons.subject_rounded,
              title: "About Me",
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    user!.bio!.trim(),
                    style: const TextStyle(fontSize: 15.5, height: 1.7),
                  ),
                ),
              ],
            ),

          if (user!.topSkills.isNotEmpty)
            _buildSection(
              icon: Icons.bolt_rounded,
              title: "Top Skills",
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: user!.topSkills
                      .map(
                        (skill) => Chip(
                          label: Text(skill),
                          backgroundColor: colorScheme.primary.withOpacity(
                            0.08,
                          ),
                          labelStyle: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          side: BorderSide(
                            color: colorScheme.primary.withOpacity(0.25),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),

          if (user!.interests != null && user!.interests!.isNotEmpty)
            _buildSection(
              icon: Icons.favorite_outline_rounded,
              title: "Interests",
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: user!.interests!
                      .map(
                        (interest) => Chip(
                          label: Text(interest),
                          backgroundColor: colorScheme.surfaceContainerHighest
                              .withOpacity(0.6),
                          labelStyle: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    List<Widget> children = const [],
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Icon(icon, size: 21, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
