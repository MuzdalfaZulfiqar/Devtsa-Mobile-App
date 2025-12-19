import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../models/post.dart';
import '../widgets/create_post_widget.dart';
import '../widgets/post_card.dart';
import 'package:provider/provider.dart';
import '../providers/auth_providers.dart';


class FeedLayout extends StatefulWidget {
  final PostService postService;
  const FeedLayout({Key? key, required this.postService}) : super(key: key);

  @override
  State<FeedLayout> createState() => _FeedLayoutState();
}

class _FeedLayoutState extends State<FeedLayout> {
  List<Post> posts = [];
  bool loading = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed({bool refresh = false}) async {
    if (loading) return;
    setState(() { loading = true; if (refresh) page = 1; });
    try {
      final res = await widget.postService.getFeed(page: page, limit: 20);
    final dataList =
    (res['posts'] as List?) ??
    (res['data'] as List?) ??
    (res['items'] as List?) ??
    [];

      final fetched = dataList.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
      setState(() {
        if (refresh) posts = fetched;
        else posts.addAll(fetched);
      });
    } catch (e) {
      debugPrint('Load feed error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load feed')));
    } finally {
      setState(() => loading = false);
    }
  }

  void _onNewPost(Post p) {
    setState(() => posts.insert(0, p));
  }

  void _onDeletePost(String id) {
    setState(() => posts.removeWhere((p) => p.id == id));
  }

  void _onEditPost(Post updated) {
    final idx = posts.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      setState(() => posts[idx] = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);


    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          CreatePostWidget(postService: widget.postService, onPostCreated: _onNewPost),
          const SizedBox(height: 12),
          ...posts.map((p) => PostCard(
  post: p,
  postService: widget.postService,
  currentUserId: auth.user?.id ?? '', // ← ADDED
  onDelete: _onDeletePost,
  onEdit: _onEditPost,
)).toList(),

if (loading) Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()),
          if (!loading)
            TextButton(
              onPressed: () {
                page++;
                _loadFeed();
              },
              child: Text('Load more'),
            )
        ],
      ),
    );
  }
}
