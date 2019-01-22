import '../../models/track.dart';
import '../../models/album.dart';

class TrackApi {
  Future<List<int>> fetchLastIds() async {
    return [1, 2, 3, 4, 5, 6, 7, 8, 9, 54];
  }

  Future<List<Track>> fetchTracksByArtistId(int id) async {
    final List<Track> result = [];
    for (var i = 1; i < 11; i++) {
      result.add(Track.fromMap({
        "id": i,
        "trackId": i,
        "name": "7it 3arfini",
        "picture": "https://i.ytimg.com/vi/odpypeUvxHw/hqdefault.jpg",
        "trackLink": "link",
        "album": Album.fromMap({"name": "Album name"}),
      }));
    }
    return result;
  }

  Future<Track> fetchItem(int id) async {
    return Track.fromMap({
      "id": id,
      "trackId": id,
      "name": "Itoub",
      "picture": "https://i.ytimg.com/vi/odpypeUvxHw/hqdefault.jpg",
      "trackLink": "link",
      "album": Album.fromMap({"name": "Album name"}),
    });
  }
}
