import '../DAO/track/track_api.dart';
import '../DAO/track/track_db.dart';
import '../models/track.dart' as TrackModel;

class Track {
  final TrackApi trackApi  = TrackApi();

  Future<List<int>> fetchLastIds() {
    return trackApi.fetchLastIds();
  }

  Future<List<TrackModel.Track>> fetchTracksByArtistId(int id) {
    return trackApi.fetchTracksByArtistId(id);
  }

  Future<TrackModel.Track> fetchItem(int id) async {
    return trackApi.fetchItem(id);
  }

  Future<List<TrackModel.Track>> fetchLastTracks() {
    return trackApi.fetchTracksByArtistId(1);
  }

  clearCache() async {
    return true;
  }

}