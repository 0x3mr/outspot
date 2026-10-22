import '../../models/comment.dart';
import '../../models/spot.dart';
import '../fixtures/sample_data.dart';
import 'spot_repository.dart';

class MockSpotRepository implements SpotRepository {
  final List<Spot> _spots = List.of(sampleSpots);
  final List<Comment> _comments = List.of(sampleComments);
  final Set<String> _likedSpotIds = {};
  final Set<String> _savedSpotIds = {};

  @override
  Future<List<Spot>> listSpots() async {
    final sorted = List<Spot>.from(_spots)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(sorted);
  }

  @override
  Future<Spot?> getSpot(String id) async {
    for (final spot in _spots) {
      if (spot.id == id) return spot;
    }
    return null;
  }

  @override
  Future<Spot> createSpot(Spot spot) async {
    _spots.add(spot);
    return spot;
  }

  @override
  Future<Spot> editSpot(Spot spot) async {
    final index = _spots.indexWhere((item) => item.id == spot.id);
    if (index == -1) throw StateError('Spot not found: ${spot.id}');
    _spots[index] = spot;
    return spot;
  }

  @override
  Future<void> deleteSpot(String id) async {
    _spots.removeWhere((spot) => spot.id == id);
  }

  @override
  Future<void> likeSpot(String id) async {
    _likedSpotIds.add(id);
  }

  @override
  Future<void> unlikeSpot(String id) async {
    _likedSpotIds.remove(id);
  }

  @override
  Future<void> saveSpot(String id) async {
    _savedSpotIds.add(id);
  }

  @override
  Future<void> unsaveSpot(String id) async {
    _savedSpotIds.remove(id);
  }

  @override
  Future<List<Comment>> listComments(String spotId) async =>
      List.unmodifiable(_comments.where((comment) => comment.spotId == spotId));

  @override
  Future<Comment> addComment(Comment comment) async {
    _comments.add(comment);
    return comment;
  }
}
