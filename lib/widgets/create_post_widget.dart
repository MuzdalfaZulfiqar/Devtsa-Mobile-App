import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/post_service.dart';
import '../models/post.dart';

class CreatePostWidget extends StatefulWidget {
  final PostService postService;
  final void Function(Post newPost)? onPostCreated;

  const CreatePostWidget({
    Key? key,
    required this.postService,
    this.onPostCreated,
  }) : super(key: key);

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final TextEditingController _textController = TextEditingController();
  List<File> _mediaFiles = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {}); // triggers rebuild so Post button updates
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result == null) return;
    final files = result.paths.whereType<String>().map((p) => File(p)).toList();
    setState(() {
      _mediaFiles.addAll(files);
    });
    final totalSize = _mediaFiles.fold<int>(
      0,
      (sum, f) => sum + f.lengthSync(),
    );
    if (_mediaFiles.length >= 2 || totalSize > 15 * 1024 * 1024) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Uploading multiple/large files — posting may take a moment.',
          ),
        ),
      );
    }
  }

  void _removeMedia(int idx) {
    setState(() {
      _mediaFiles.removeAt(idx);
    });
  }

  Future<void> _submit() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _mediaFiles.isEmpty) return;
    setState(() => _loading = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Uploading your post… please wait.')),
    );

    try {
      final res = await widget.postService.createPost(
        text: text,
        mediaFiles: _mediaFiles,
      );
      final postJson = res['post'] ?? res;
      final newPost = Post.fromJson(postJson as Map<String, dynamic>);
      _textController.clear();
      setState(() => _mediaFiles = []);
      widget.onPostCreated?.call(newPost);
    } catch (e) {
      debugPrint('Create post failed: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create post')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
  radius: 22,
  backgroundColor: Color(0xFF086972), // your teal color
  child: Icon(Icons.person, color: Colors.white), // optional: white icon inside
),
 // replace with your DevstaAvatar
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    minLines: 1,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Share something with the community...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            if (_mediaFiles.isNotEmpty)
              Container(
                height: 96,
                margin: const EdgeInsets.only(top: 8),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, i) {
                    final f = _mediaFiles[i];
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (c) => Dialog(child: Image.file(f)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              f,
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -6,
                          top: -6,
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () => _removeMedia(i),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(width: 8),
                  itemCount: _mediaFiles.length,
                ),
              ),
            SizedBox(height: 8),
            Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    ElevatedButton(
      onPressed:
          _loading ||
                  (_textController.text.trim().isEmpty &&
                      _mediaFiles.isEmpty)
              ? null
              : _submit,
      child: _loading ? const Text('Posting...') : const Text('Post'),
      style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
    ),
  ],
),

          ],
        ),
      ),
    );
  }
}
