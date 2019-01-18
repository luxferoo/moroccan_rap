import '../../models/track.dart';
import '../../models/album.dart';

class TrackApi {
  Future<List<int>> fetchLastIds() async {
    return [1,2,3,4];
  }

  Future<Track> fetchItem(int id) async {
    return Track.fromMap({
      "id": id,
      "trackId": id,
      "name": "Track name-$id",
      "picture": "https://i.ytimg.com/vi/daGpTlirY0I/maxresdefault.jpg",
      "trackLink": "link",
      "album": Album.fromMap({"name": "Album name"}),
    });
  }
}
