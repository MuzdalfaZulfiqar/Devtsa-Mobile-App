import '../feed_layout.dart';
import '../feed_screen.dart';
import 'package:flutter/material.dart';
import 'explore_screen.dart';
import '../../services/post_service.dart';
import 'my_connections_screen.dart';
/// Reusable scaffold for Community tabs
class CommunityTabsScaffold extends StatelessWidget {
  final Widget explore;
  final Widget feed;
  final Widget connections;

  const CommunityTabsScaffold({
    super.key,
    required this.explore,
    required this.feed,
    required this.connections,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1, // Set FEED as default active tab
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.blue,
            tabs: [
              Tab(text: 'Explore'),
              Tab(text: 'Feed'),
              Tab(text: 'My Connections'),
            ],
          ),
          Expanded(child: TabBarView(children: [explore, feed, connections])),
        ],
      ),
    );
  }
}

/// Main Community Screen used in navigation
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityTabsScaffold(
      
        explore: const ExploreScreen(),

      // ✅ REAL FEED CONNECTED HERE
      // feed: FeedLayout(
      //   postService: PostService(
      //     backendUrl: 'https://devsta-backend.onrender.com',
      //   ),
      // ),
      feed: FeedLayout(
        postService: PostService(
          backendUrl: 'https://devsta-backend.onrender.com',
        ),
      ),

      connections: const MyConnectionsScreen(),
    );
  }
}
