import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_providers.dart';
import '../../services/community_api.dart';
import '../../models/community_user.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool _isLoading = false;
  String? _error;
  List<CommunityUser> _users = [];
  final Set<String> _requestLoading = {};

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadExploreUsers();
  }

  Future<void> _loadExploreUsers() async {
    final auth = context.read<AuthProvider>();
    final String? authToken = auth.token; // same as Dashboard

    if (authToken == null || authToken.isEmpty) {
      setState(() {
        _error = 'You need to be logged in to see suggestions.';
        _users = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final users = await CommunityApi.fetchExploreUsers(authToken);
      setState(() {
        _users = users;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleConnect(CommunityUser user) async {
    final auth = context.read<AuthProvider>();
    final String? authToken = auth.token;

    if (authToken == null || authToken.isEmpty) return;

    setState(() {
      _requestLoading.add(user.id);
    });

    try {
      final newStatus =
          await CommunityApi.sendConnectionRequest(authToken, user.id);

      setState(() {
        _users = _users.map((u) {
          if (u.id == user.id) {
            return u.copyWith(connectionStatus: newStatus);
          }
          return u;
        }).toList();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send request: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _requestLoading.remove(user.id);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Failed to load suggestions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadExploreUsers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_users.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadExploreUsers,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SearchBar(
              query: _searchQuery,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'No suggestions right now.\nPull down to refresh.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ---------- search filtering ----------
    final query = _searchQuery.trim().toLowerCase();
    final filtered = _users.where((u) {
      if (query.isEmpty) return true;

      final name = u.name.toLowerCase();
      final role = (u.primaryRole ?? '').toLowerCase();
      final skills = u.topSkills.map((s) => s.toLowerCase());

      if (name.contains(query)) return true;
      if (role.contains(query)) return true;
      if (skills.any((s) => s.contains(query))) return true;

      return false;
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadExploreUsers,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 1 + (filtered.isEmpty ? 1 : filtered.length),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            // 🔍 Search bar card at the top
            return _SearchBar(
              query: _searchQuery,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            );
          }

          if (filtered.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Text(
                  'No users match your search.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            );
          }

          final user = filtered[index - 1];
          final isBusy = _requestLoading.contains(user.id);

          return _ExploreUserCard(
            user: user,
            isBusy: isBusy,
            onConnect: () => _handleConnect(user),
          );
        },
      ),
    );
  }
}

/// Search bar UI (styled similar to your dashboard cards)
class _SearchBar extends StatelessWidget {
  final String query;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.query,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search developers, roles, skills…',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: theme.colorScheme.primary,
            ),
            border: InputBorder.none,
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ExploreUserCard extends StatelessWidget {
  final CommunityUser user;
  final bool isBusy;
  final VoidCallback onConnect;

  const _ExploreUserCard({
    required this.user,
    required this.isBusy,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Decide button label & state based on connectionStatus
    late String buttonLabel;
    bool buttonEnabled = true;

    if (user.isConnected) {
      buttonLabel = 'Connected';
      buttonEnabled = false;
    } else if (user.isPendingSent) {
      buttonLabel = 'Requested';
      buttonEnabled = false;
    } else if (user.isPendingReceived) {
      buttonLabel = 'Respond';
      buttonEnabled = false; // for now keep disabled, same logic
    } else {
      buttonLabel = 'Connect';
      buttonEnabled = !isBusy;
    }

    return Material(
      color: theme.colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage:
                  (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                      ? NetworkImage(user.avatarUrl!)
                      : null,
              child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                  ? Text(
                      user.name.isNotEmpty
                          ? user.name[0].toUpperCase()
                          : '?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (user.primaryRole != null &&
                      user.primaryRole!.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        user.primaryRole!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                  if (user.topSkills.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: -4,
                      children: user.topSkills
                          .take(3)
                          .map(
                            (s) => Chip(
                              label: Text(
                                s,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                                  theme.colorScheme.primary.withOpacity(0.08),
                              side: BorderSide(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.3),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: buttonEnabled ? onConnect : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonEnabled
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  foregroundColor: buttonEnabled
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: isBusy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        buttonLabel,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
