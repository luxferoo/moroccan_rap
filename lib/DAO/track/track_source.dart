import '../../models/track.dart';

abstract class TrackSource {
  Future<List<int>> fetchLastIds();

  Future<Track> fetchTrack(int id);

  Future<List<Track>> fetchTracksByArtistId(int id);
}