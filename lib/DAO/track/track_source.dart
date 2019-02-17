import '../../models/track.dart';

abstract class TrackSource {
  Future<Track> fetchTrack(int id);

  Future<List<Track>> fetchTracksByArtistId(int id);

  Future<List<Track>> fetchRecentTracks();
}
