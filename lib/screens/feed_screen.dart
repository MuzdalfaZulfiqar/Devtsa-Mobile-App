import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../widgets/post_card.dart';
import '../widgets/create_post_widget.dart';
import '../models/post.dart';
import 'package:provider/provider.dart';
import '../providers/auth_providers.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final PostService _postService;
  late Future<List<Post>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _postService = PostService(
      backendUrl: 'https://devsta-backend.onrender.com',
    );
    _futurePosts = _loadPosts();
  }

  Future<List<Post>> _loadPosts() async {
    final list = await _postService.getAllPosts();
    return list.map((json) => Post.fromJson(json)).toList();
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _futurePosts = _loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final currentUserId = auth.user?.id ?? '';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: CreatePostWidget(
            postService: _postService, // ← REQUIRED
            onPostCreated: (newPost) {
              _refreshPosts();
            },
          ),
        ),

        Expanded(
          child: FutureBuilder<List<Post>>(
            future: _futurePosts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final posts = snapshot.data ?? [];

              if (posts.isEmpty) {
                return const Center(child: Text("No posts yet."));
              }

              return RefreshIndicator(
                onRefresh: _refreshPosts,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(
                      post: posts[index],
                      postService: _postService,
                      currentUserId: currentUserId, // ← ADDED
                      onDelete: (id) => _refreshPosts(),
                      onEdit: (updated) => _refreshPosts(),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
