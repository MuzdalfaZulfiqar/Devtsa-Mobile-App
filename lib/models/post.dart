import 'user_profile.dart';

class Post {
  final UserProfile author;
  final String content;
  int likes;
  List<String> comments;
  final DateTime timestamp;

  Post({
    required this.author,
    required this.content,
    this.likes = 0,
    List<String>? comments,
    DateTime? timestamp,
  })  : comments = comments ?? <String>[],
        timestamp = timestamp ?? DateTime.now();

  // To allow using Post in Set
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post &&
          runtimeType == other.runtimeType &&
          author == other.author &&
          content == other.content &&
          timestamp == other.timestamp;

  @override
  int get hashCode => author.hashCode ^ content.hashCode ^ timestamp.hashCode;
}
