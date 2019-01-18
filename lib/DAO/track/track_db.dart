import '../../models/track.dart';
import '../../models/album.dart';

class TrackDb {
  Future<List<int>> fetchIds() async {
    return [1];
  }

  Future<Track> fetchItem(int id) async {
    return Track.fromMap({
      "id": 1,
      "trackId": 1,
      "name": "Track name",
      "picture": "picture",
      "trackLink": "link",
      "album": Album.fromMap({"name": "Album name"}),
    });
  }
}
