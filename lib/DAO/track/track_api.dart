import '../../models/track.dart';

class TrackApi {
  Future<List<int>> fetchLastIds() async {
    return [1, 2, 3];
  }

  Future<List<Track>> fetchTracksByArtistId(int id) async {
    final List<Track> result = [];
    result.add(Track.fromMap({
      "id": 1,
      "trackId": 1,
      "name": "7it 3arfini 1",
      "artistName": "shayfeen 1",
      "picture": "https://i.ytimg.com/vi/odpypeUvxHw/hqdefault.jpg",
      "artistPicture":
          "http://qgprod.com/wp-content/uploads/2013/10/shayfeen-ep-.jpg",
      "link":
          "https://api.soundcloud.com/tracks/434370309/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P",
      "album": "Album",
      "duration": "3:22",
    }));

    result.add(Track.fromMap({
      "id": 2,
      "trackId": 2,
      "name": "7it 3arfini 2",
      "artistName": "shayfeen 2",
      "picture":
      "http://qgprod.com/wp-content/uploads/2013/10/shayfeen-ep-.jpg",
      "artistPicture": "https://i.ytimg.com/vi/odpypeUvxHw/hqdefault.jpg",
      "link":
      "https://api.soundcloud.com/tracks/402538329/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P",
      "album": "Album",
      "duration": "3:22",
    }));


    result.add(Track.fromMap({
      "id": 3,
      "trackId": 3,
      "name": "7it 3arfini 3",
      "artistName": "shayfeen 3",
      "picture":
      "http://qgprod.com/wp-content/uploads/2013/10/shayfeen-ep-.jpg",
      "artistPicture": "https://i.ytimg.com/vi/odpypeUvxHw/hqdefault.jpg",
      "link":
      "https://api.soundcloud.com/tracks/266891990/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P",
      "album": "Album",
      "duration": "3:22",
    }));
    return result;
  }

  Future<Track> fetchItem(int id) async {
    return Track.fromMap({
      "id": id,
      "trackId": id,
      "name": "itoub $id",
      "artistName": "Don bigg $id",
      "picture": "https://i.ytimg.com/vi/odpypeUvxHw/hqdefault.jpg",
      "artistPicture": "https://i.ytimg.com/vi/odpypeUvxHw/hqdefault.jpg",
      "link":
          "https://api.soundcloud.com/tracks/434370309/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P",
      "album": "Album",
      "duration": "3:22",
    });
  }
}
