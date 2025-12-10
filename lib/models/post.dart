class Post {
  final String id;
  final Map<String, dynamic>? author;
  final String? text;
  final List<String> mediaUrls;
  final String createdAt;
  int likesCount;
  bool likedByCurrentUser;
  int commentsCount;

  Post({
    required this.id,
    this.author,
    this.text,
    this.mediaUrls = const [],
    required this.createdAt,
    this.likesCount = 0,
    this.likedByCurrentUser = false,
    this.commentsCount = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? json['id'],
      author: json['author'] as Map<String, dynamic>?,
      text: json['text'] as String?,
      mediaUrls: (json['media'] as List<dynamic>?)
            ?.map((m) => m['url'] as String)
            .toList() ??
          (json['mediaUrls'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: json['createdAt'] ?? '',
      likesCount: json['likesCount'] ?? json['likes'] ?? 0,
      likedByCurrentUser: json['likedByCurrentUser'] ?? false,
      commentsCount: json['commentsCount'] ?? 0,
    );
  }
}

