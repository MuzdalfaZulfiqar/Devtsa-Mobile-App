import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_providers.dart';
import '../../services/community_api.dart';
import '../../models/community_user.dart';

class MyConnectionsScreen extends StatefulWidget {
  const MyConnectionsScreen({super.key});

  @override
  State<MyConnectionsScreen> createState() => _MyConnectionsScreenState();
}

class _MyConnectionsScreenState extends State<MyConnectionsScreen> {
  bool _isLoading = false;
  String? _error;

  List<CommunityUser> _connectedUsers = [];
  List<CommunityUser> _sentRequests = [];
  List<CommunityUser> _receivedRequests = [];

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadConnections();
  }

  Future<void> _loadConnections() async {
    final auth = context.read<AuthProvider>();
    final String? authToken = auth.token; // same token as Dashboard

    if (authToken == null || authToken.isEmpty) {
      setState(() {
        _error = 'You need to be logged in to see your connections.';
        _connectedUsers = [];
        _sentRequests = [];
        _receivedRequests = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Same endpoint as Explore: /api/connections
      final items =
          await CommunityApi.fetchExploreUsers(authToken, page: 1, limit: 300);

      setState(() {
        _connectedUsers = items
            .where((u) => u.connectionStatus == 'accepted')
            .toList();
        _sentRequests = items
            .where((u) => u.connectionStatus == 'pending_sent')
            .toList();
        _receivedRequests = items
            .where((u) => u.connectionStatus == 'pending_received')
            .toList();
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
                'Failed to load connections',
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
                onPressed: _loadConnections,
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

    // Filter "Your Connections" by search text
    final filteredConnected = _connectedUsers.where((u) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return u.name.toLowerCase().contains(q) ||
          (u.primaryRole ?? '').toLowerCase().contains(q);
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadConnections,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ----- Your Connections (with search) -----
          _ConnectionsSection(
            title: 'Your Connections',
            count: filteredConnected.length,
            child: Column(
              children: [
                _ConnectionsSearchBar(
                  query: _searchQuery,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                if (filteredConnected.isEmpty)
                  Text(
                    'No connections found.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  )
                else
                  ...filteredConnected.map(
                    (u) => Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 6.0),
                      child: _ConnectionUserCard(
                        user: u,
                        trailingLabel: 'Connected',
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ----- Pending Responses (requests you sent) -----
          _ConnectionsSection(
            title: 'Pending Responses',
            count: _sentRequests.length,
            child: _sentRequests.isEmpty
                ? Text(
                    'No pending responses.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  )
                : Column(
                    children: _sentRequests.map(
                      (u) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0),
                        child: _ConnectionUserCard(
                          user: u,
                          trailingLabel: 'Request Sent',
                        ),
                      ),
                    ).toList(),
                  ),
          ),

          const SizedBox(height: 16),

          // ----- Requests For You (requests you received) -----
          _ConnectionsSection(
            title: 'Requests For You',
            count: _receivedRequests.length,
            child: _receivedRequests.isEmpty
                ? Text(
                    'No incoming requests.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  )
                : Column(
                    children: _receivedRequests.map(
                      (u) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0),
                        child: _ConnectionUserCard(
                          user: u,
                          trailingLabel: 'Requested You',
                        ),
                      ),
                    ).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionsSection extends StatelessWidget {
  final String title;
  final int count;
  final Widget child;

  const _ConnectionsSection({
    required this.title,
    required this.count,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title ($count)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// Search bar styled similar to DashboardCard vibes
class _ConnectionsSearchBar extends StatelessWidget {
  final String query;
  final ValueChanged<String> onChanged;

  const _ConnectionsSearchBar({
    required this.query,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search connections…',
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

class _ConnectionUserCard extends StatelessWidget {
  final CommunityUser user;
  final String trailingLabel;

  const _ConnectionUserCard({
    required this.user,
    required this.trailingLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.6),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage:
                  (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                      ? NetworkImage(user.avatarUrl!)
                      : null,
              child: (user.avatarUrl == null ||
                      user.avatarUrl!.isEmpty)
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
                    style: theme.textTheme.bodyLarge?.copyWith(
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
                          color: theme.colorScheme.onSurface
                              .withOpacity(0.7),
                        ),
                      ),
                    ),
                  if (user.topSkills.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: -4,
                      children: user.topSkills
                          .take(3)
                          .map(
                            (s) => Chip(
                              label: Text(
                                s,
                                style: theme.textTheme.labelSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity:
                                  VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize
                                      .shrinkWrap,
                              backgroundColor:
                                  theme.colorScheme.primary
                                      .withOpacity(0.08),
                              side: BorderSide(
                                color: theme.colorScheme.primary
                                    .withOpacity(0.3),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                trailingLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
