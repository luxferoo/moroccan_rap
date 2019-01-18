import '../DAO/track/track_api.dart';
import '../DAO/track/track_db.dart';
import '../models/track.dart' as TrackModel;

class Track {
  final TrackApi trackApi  = TrackApi();

  Future<List<int>> fetchLastIds() {
    return trackApi.fetchLastIds();
  }

  Future<TrackModel.Track> fetchItem(int id) async {
    return trackApi.fetchItem(id);
  }

  clearCache() async {
    return true;
  }
}