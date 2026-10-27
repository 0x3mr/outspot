import '../../models/comment.dart';
import '../../models/spot.dart';

abstract class SpotRepository {
  Future<List<Spot>> listSpots();

  Future<Spot?> getSpot(String id);

  Future<Spot> createSpot(Spot spot);

  Future<Spot> editSpot(Spot spot);

  Future<void> deleteSpot(String id);

  Future<void> likeSpot(String id);

  Future<void> unlikeSpot(String id);

  Future<void> saveSpot(String id);

  Future<void> unsaveSpot(String id);

  Future<List<Spot>> listSavedSpots();

  Future<List<Comment>> listComments(String spotId);

  Future<Comment> addComment(Comment comment);
}
