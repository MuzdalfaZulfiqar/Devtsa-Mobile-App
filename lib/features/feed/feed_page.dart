import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../models/post.dart';
import '../../widgets/app_bar_with_border.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final app = AppState();
  final _postController = TextEditingController();
  final Set<Post> likedPosts = {};
  final Set<Post> savedPosts = {};

  @override
  void initState() {
    super.initState();
    app.seedFeed();
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  void _addPost() {
    final text = _postController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      app.addPost(text);
      _postController.clear();
    });
  }

  String _formatTimestamp(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    final feed = app.feed;

    return Scaffold(
      appBar: appBarWithBorder(
        'DevSta Feed',
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SavedPostsPage(savedPosts: savedPosts),
                ),
              );
            },
            iconSize: 20,
            color: Colors.teal,
          ),
        ],
      ),
      body: Column(
        children: [
          // Heading above post box
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: const Text(
              'Add Post',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          // New Post Box
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Text(app.profile.displayName.isNotEmpty
                      ? app.profile.displayName[0]
                      : 'D'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF0F2F5),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addPost,
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                  ),
                  child: const Text('Post'),
                )
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Feed
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: feed.length,
              itemBuilder: (context, index) {
                final post = feed[index];
                final liked = likedPosts.contains(post);
                final saved = savedPosts.contains(post);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.teal,
                              child: Text(post.author.displayName.isNotEmpty
                                  ? post.author.displayName[0]
                                  : 'U'),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.author.displayName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text(
                                  _formatTimestamp(post.timestamp),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(post.content),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Like button
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (liked) {
                                    post.likes--;
                                    likedPosts.remove(post);
                                  } else {
                                    post.likes++;
                                    likedPosts.add(post);
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    liked
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_alt_outlined,
                                    color: liked ? Colors.teal : Colors.grey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('${post.likes}',
                                      style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),

                            // Save button
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (saved) {
                                    savedPosts.remove(post);
                                  } else {
                                    savedPosts.add(post);
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    saved
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: Colors.teal,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('Save',
                                      style:
                                          const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF0F2F5),
    );
  }
}

class SavedPostsPage extends StatefulWidget {
  final Set<Post> savedPosts;

  const SavedPostsPage({super.key, required this.savedPosts});

  @override
  State<SavedPostsPage> createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage> {
  final Set<Post> likedPosts = {};

  String _formatTimestamp(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    final posts = widget.savedPosts.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Posts'),
        backgroundColor: Colors.white,
      ),
      body: posts.isEmpty
          ? const Center(child: Text('No saved posts yet.'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final liked = likedPosts.contains(post);
                final saved = widget.savedPosts.contains(post);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.teal,
                              child: Text(post.author.displayName.isNotEmpty
                                  ? post.author.displayName[0]
                                  : 'U'),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.author.displayName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text(
                                  _formatTimestamp(post.timestamp),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(post.content),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Like button
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (liked) {
                                    post.likes--;
                                    likedPosts.remove(post);
                                  } else {
                                    post.likes++;
                                    likedPosts.add(post);
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    liked
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_alt_outlined,
                                    color: liked ? Colors.teal : Colors.grey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('${post.likes}',
                                      style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),

                            // Save/Unsave button
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (saved) {
                                    widget.savedPosts.remove(post);
                                  } else {
                                    widget.savedPosts.add(post);
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    saved
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: Colors.teal,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('Save',
                                      style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
