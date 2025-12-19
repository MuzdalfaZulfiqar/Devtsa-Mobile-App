// // lib/screens/community/community_screen.dart
// import 'package:flutter/material.dart';
// import '../screens/feed_screen.dart';

// /// Reusable scaffold for Community tabs
// /// You can reuse this later and just pass different widgets
// class CommunityTabsScaffold extends StatelessWidget {
//   final Widget explore;
//   final Widget feed;
//   final Widget connections;

//   const CommunityTabsScaffold({
//     super.key,
//     required this.explore,
//     required this.feed,
//     required this.connections,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       initialIndex: 0, // 0 = Explore (default)
//       child: Scaffold(
//         appBar: AppBar(
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'Explore'),
//               Tab(text: 'Feed'),
//               Tab(text: 'My Connections'),
//             ],
//           ),
//         ),
//         body: TabBarView(children: [explore, feed, connections]),
//       ),
//     );
//   }
// }

// /// This is the screen you will use in navigation / bottom nav.
// /// Right now it only wires up the tabs with placeholder content.
// /// Later you'll replace these placeholders with real Explore/Feed/Connection screens.
// class CommunityScreen extends StatelessWidget {
//   const CommunityScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CommunityTabsScaffold(
//       explore: const Center(
//         child: Text('Explore – implementation coming soon'),
//       ),
//       feed: const Center(child: Text('Feed – implementation coming soon')),
//       connections: const Center(
//         child: Text('My Connections – implementation coming soon'),
//       ),
//     );
//   }
// }

// lib/screens/community/community_screen.dart

import 'package:flutter/material.dart';
import '../screens/feed_screen.dart';
import '../screens/feed_layout.dart';
import '../services/post_service.dart';

import 'explore_screen.dart';
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
<<<<<<< HEAD:lib/screens/community_screen.dart
      explore: const Center(
        child: Text('Explore – implementation coming soon'),
      ),

      /// 🔥 Feed tab properly connected here!
      feed: FeedLayout(
        postService: PostService(
          backendUrl: 'https://devsta-backend.onrender.com',
        ),
      ),

      connections: const Center(
        child: Text('My Connections – implementation coming soon'),
      ),
=======
      explore: const ExploreScreen(),
      feed: const Center(
        child: Text('Feed – implementation coming soon'),
      ),
      connections: const MyConnectionsScreen(),
>>>>>>> 0cff3409779e578cf195def90f4b2d08aadedb87:lib/screens/community/community_screen.dart
    );
  }
}
