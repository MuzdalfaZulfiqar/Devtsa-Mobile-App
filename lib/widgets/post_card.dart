
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import 'package:google_fonts/google_fonts.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final PostService postService;
  final void Function(String id)? onDelete;
  final void Function(Post updated)? onEdit;
  final String currentUserId;

  const PostCard({
    Key? key,
    required this.post,
    required this.postService,
    required this.currentUserId,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Post postState;
  bool likedLoading = false;
  bool isEditing = false;
  bool showComments = false;
  final TextEditingController _editController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  List<File> newFiles = [];
  List<String> removedPublicIds = [];
  List<dynamic> comments = [];
  bool loadingComments = false;

  @override
  void initState() {
    super.initState();
    postState = widget.post;
    _editController.text = postState.text ?? '';
  }

  @override
  void dispose() {
    _editController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // Your methods — 100% unchanged
  Future<void> _toggleLike() async {
    if (likedLoading) return;
    final currentLiked = postState.likedByCurrentUser ?? false;
    final willLike = !currentLiked;
    final previousCount = postState.likesCount ?? 0;

    setState(() {
      postState.likedByCurrentUser = willLike;
      postState.likesCount = willLike ? previousCount + 1 : (previousCount > 0 ? previousCount - 1 : 0);
      likedLoading = true;
    });

    try {
      if (willLike) {
        await widget.postService.likePost(postState.id);
      } else {
        await widget.postService.unlikePost(postState.id);
      }
    } catch (_) {
      setState(() {
        postState.likedByCurrentUser = currentLiked;
        postState.likesCount = previousCount;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update like')));
      }
    } finally {
      if (mounted) setState(() => likedLoading = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await widget.postService.deletePost(postState.id);
      widget.onDelete?.call(postState.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post deleted successfully')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete post')));
      }
    }
  }

  Future<void> _saveEdit() async {
    final newText = _editController.text.trim();
    final textUnchanged = newText == (postState.text?.trim() ?? '');
    if (textUnchanged && newFiles.isEmpty && removedPublicIds.isEmpty) {
      setState(() => isEditing = false);
      return;
    }

    try {
      final res = await widget.postService.updatePost(
        postState.id,
        text: newText.isEmpty ? '' : newText,
        newFiles: newFiles,
        removePublicIds: removedPublicIds,
      );

      final updatedJson = res['post'] ?? res;
      final updatedPost = Post.fromJson(updatedJson as Map<String, dynamic>);

      setState(() {
        postState = updatedPost;
        isEditing = false;
        newFiles.clear();
        removedPublicIds.clear();
      });

      widget.onEdit?.call(updatedPost);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post updated')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update post')));
      }
    }
  }

  Future<void> _loadComments() async {
    setState(() => loadingComments = true);
    try {
      final res = await widget.postService.listComments(postState.id);
      setState(() => comments = res['items'] ?? []);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load comments')));
      }
    } finally {
      if (mounted) setState(() => loadingComments = false);
    }
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    try {
      final res = await widget.postService.addComment(postState.id, text);
      setState(() {
        comments.insert(0, res['comment']);
        _commentController.clear();
        postState.commentsCount += 1;
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add comment')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final teal = colorScheme.primary; // Your #086972 from seed

    final authorName = postState.author?['name'] ?? 'Unknown User';
    final avatarUrl = postState.author?['avatarUrl'] as String?;
    final isOwner = postState.author?['_id'] == widget.currentUserId;
    final bool isLiked = postState.likedByCurrentUser ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.35)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: teal.withOpacity(0.15),
                    backgroundImage: avatarUrl != null ? CachedNetworkImageProvider(avatarUrl) : null,
                    child: avatarUrl == null
                        ? Text(
                            authorName[0].toUpperCase(),
                            style: GoogleFonts.lato(fontWeight: FontWeight.w700, color: teal),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(authorName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(postState.createdAt, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  if (isOwner)
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_horiz_rounded, color: colorScheme.onSurfaceVariant),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit_outlined), title: Text('Edit'))),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(leading: Icon(Icons.delete_outline, color: colorScheme.error), title: Text('Delete', style: TextStyle(color: colorScheme.error))),
                        ),
                      ],
                      onSelected: (v) => v == 'edit' ? setState(() => isEditing = true) : _delete(),
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // Post Text
              if (isEditing)
                TextField(
                  controller: _editController,
                  maxLines: null,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    filled: true,
                    fillColor: teal.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: teal, width: 2)),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                )
              else if ((postState.text ?? '').isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(postState.text!, style: theme.textTheme.bodyLarge?.copyWith(height: 1.55)),
                ),

              // Media
              if (!isEditing && postState.mediaUrls.isNotEmpty) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 1.3,
                    child: CachedNetworkImage(imageUrl: postState.mediaUrls[0], fit: BoxFit.cover, width: double.infinity),
                  ),
                ),
                if (postState.mediaUrls.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('+${postState.mediaUrls.length - 1} more', style: TextStyle(color: teal, fontWeight: FontWeight.w600)),
                  ),
              ],

              // Edit buttons
              if (isEditing)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Wrap(
                    spacing: 10,
                    children: [
                      // OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.add_photo_alternate_outlined), label: const Text('Add Photo')),
                      TextButton(onPressed: () => setState(() => isEditing = false), child: const Text('Cancel')),
                      FilledButton(onPressed: _saveEdit, child: const Text('Save')),
                    ],
                  ),
                ),

              const SizedBox(height: 14),

              // Like & Comment Row — using your teal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: likedLoading ? null : _toggleLike,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child: Icon(
                                isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                                key: ValueKey(isLiked),
                                color: isLiked ? teal : colorScheme.onSurfaceVariant,
                                size: 23,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              postState.likesCount == 0 ? 'Like' : '${postState.likesCount}',
                              style: TextStyle(color: isLiked ? teal : colorScheme.onSurfaceVariant, fontWeight: isLiked ? FontWeight.w600 : FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () async {
                        if (!showComments && comments.isEmpty) await _loadComments();
                        setState(() => showComments = !showComments);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline_rounded, size: 23, color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: 7),
                            Text(
                              postState.commentsCount == 0 ? 'Comment' : '${postState.commentsCount}',
                              style: TextStyle(color: colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Comments
              if (showComments) ...[
                const Divider(height: 32),
                loadingComments
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          for (var comment in comments)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: teal.withOpacity(0.15),
                                    child: Text(
                                      (comment['author']['name'] ?? 'U')[0].toUpperCase(),
                                      style: TextStyle(color: teal, fontWeight: FontWeight.w700, fontSize: 13),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: teal.withOpacity(0.06),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Text(comment['text'] ?? '', style: theme.textTheme.bodyMedium),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  decoration: InputDecoration(
                                    hintText: 'Write a comment...',
                                    filled: true,
                                    fillColor: teal.withOpacity(0.08),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(Icons.send_rounded, color: teal, size: 26),
                                onPressed: _addComment,
                              ),
                            ],
                          ),
                        ],
                      ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}