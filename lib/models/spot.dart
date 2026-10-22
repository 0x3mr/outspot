import 'profile.dart';

class Spot {
  const Spot({
    required this.id,
    required this.author,
    required this.caption,
    required this.createdAt,
    this.placeName,
    this.latitude,
    this.longitude,
    this.photoReference,
    this.tags = const [],
    this.budgetLabel,
  });

  final String id;
  final Profile author;
  final String caption;
  final DateTime createdAt;
  final String? placeName;
  final double? latitude;
  final double? longitude;
  final String? photoReference;
  final List<String> tags;
  final String? budgetLabel;
}
