import 'profile.dart';

class Comment {
  const Comment({
    required this.id,
    required this.spotId,
    required this.author,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String spotId;
  final Profile author;
  final String text;
  final DateTime createdAt;
}
