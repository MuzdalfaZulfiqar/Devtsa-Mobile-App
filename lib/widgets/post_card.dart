import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final PostService postService;
  final void Function(String id)? onDelete;
  final void Function(Post updated)? onEdit;

  const PostCard({Key? key, required this.post, required this.postService, this.onDelete, this.onEdit}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Post postState;
  bool likedLoading = false;
  bool isEditing = false;
  final TextEditingController _editController = TextEditingController();
  List<File> newFiles = [];
  List<String> removedPublicIds = [];

  @override
  void initState() {
    super.initState();
    postState = widget.post;
    _editController.text = postState.text ?? '';
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  Future<void> _toggleLike() async {
    if (likedLoading) return;
    final willLike = !postState.likedByCurrentUser;
    final previousLiked = postState.likedByCurrentUser;
    final previousCount = postState.likesCount;

    // optimistic update
    setState(() {
      postState.likedByCurrentUser = willLike;
      postState.likesCount = willLike ? postState.likesCount + 1 : postState.likesCount - 1;
      likedLoading = true;
    });

    try {
      if (willLike) {
        await widget.postService.likePost(postState.id);
      } else {
        await widget.postService.unlikePost(postState.id);
      }
    } catch (e) {
      // revert
      setState(() {
        postState.likedByCurrentUser = previousLiked;
        postState.likesCount = previousCount;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update like')));
    } finally {
      setState(() => likedLoading = false);
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Delete post?'),
        content: Text('This will permanently delete the post.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(c).pop(true), child: Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await widget.postService.deletePost(postState.id);
      widget.onDelete?.call(postState.id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post deleted')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete post')));
    }
  }

  Future<void> _saveEdit() async {
    final newText = _editController.text.trim();
    if (newText.isEmpty && newFiles.isEmpty && removedPublicIds.isEmpty) return;
    try {
      final res = await widget.postService.updatePost(postState.id, text: newText, newFiles: newFiles, removePublicIds: removedPublicIds);
      final updatedJson = res['post'] ?? res;
      final updated = Post.fromJson(updatedJson as Map<String, dynamic>);
      setState(() {
        postState = updated;
        isEditing = false;
        newFiles = [];
        removedPublicIds = [];
      });
      widget.onEdit?.call(updated);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post updated')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update post')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authorName = postState.author?['name'] ?? 'Unknown';
    final createdAt = postState.createdAt;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Row(
              children: [
                CircleAvatar(radius: 20),
                SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(authorName, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(createdAt, style: TextStyle(fontSize: 12, color: Colors.grey)),
                ])),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit') {
                      setState(() { isEditing = true; _editController.text = postState.text ?? ''; });
                    }
                    if (v == 'delete') _delete();
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                  ],
                )
              ],
            ),

            const SizedBox(height: 8),
            if (!isEditing && (postState.text ?? '').isNotEmpty)
              Text(postState.text ?? '', style: TextStyle(fontSize: 14)),
            // media thumbnails
            if (!isEditing && postState.mediaUrls.isNotEmpty)
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 220,
                child: GestureDetector(
                  onTap: () {
                    // show first media in dialog; you can implement lightbox navigation
                    showDialog(context: context, builder: (c) => Dialog(child: CachedNetworkImage(imageUrl: postState.mediaUrls[0])));
                  },
                  child: CachedNetworkImage(imageUrl: postState.mediaUrls[0], fit: BoxFit.cover),
                ),
              ),

            if (isEditing)
              Column(children: [
                TextField(controller: _editController, maxLines: 4),
                Row(children: [
                  TextButton.icon(onPressed: () {/* open FilePicker add to newFiles */}, icon: Icon(Icons.image), label: Text('Add Photo')),
                  Spacer(),
                  TextButton(onPressed: () => setState(() => isEditing = false), child: Text('Cancel')),
                  ElevatedButton(onPressed: _saveEdit, child: Text('Save')),
                ]),
              ]),

            const SizedBox(height: 12),
            Row(children: [
              InkWell(
                onTap: _toggleLike,
                child: Row(children: [
                  Icon(postState.likedByCurrentUser ? Icons.thumb_up : Icons.thumb_up_outlined, color: postState.likedByCurrentUser ? Theme.of(context).primaryColor : Colors.grey),
                  SizedBox(width: 6),
                  Text('${postState.likesCount} Like${postState.likesCount == 1 ? '' : 's'}'),
                ]),
              ),
              const SizedBox(width: 16),
              InkWell(onTap: () {}, child: Row(children: [Icon(Icons.comment_outlined), SizedBox(width: 6), Text('${postState.commentsCount} Comment${postState.commentsCount == 1 ? '' : 's'}')])),
            ])
          ],
        ),
      ),
    );
  }
}
