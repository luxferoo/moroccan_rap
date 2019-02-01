import '../../models/track.dart';

abstract class TrackCache {
  addTrack(Track track);

  Future<int> clear();
}