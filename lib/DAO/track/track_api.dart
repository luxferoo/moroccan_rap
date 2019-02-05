import '../../models/track.dart';
import 'track_source.dart';
import 'dart:convert';
import 'package:http/http.dart' show Client;
import '../../Helpers/globals.dart';

class TrackApi implements TrackSource {
  final globals = Globals();
  final _client = Client();

  @override
  Future<List<int>> fetchLastIds() async {
    final response = await _client.get('${globals.tracksRoot}/recentIds');
    if (response.statusCode == 200)
      return jsonDecode(response.body).cast<int>();
    return null;
  }

  @override
  Future<List<Track>> fetchTracksByArtistId(int id) async {
    final response = await _client.get('${globals.artistsRoot}/$id/tracks');
    if (response.statusCode == 200) {
      final List<Track> tracks = jsonDecode(response.body)
          .map((track) {
            return Track.fromMap(track);
          })
          .toList()
          .cast<Track>();
      return tracks;
    }
    return null;
  }

  @override
  Future<Track> fetchTrack(int id) async {
    final response = await _client.get('${globals.tracksRoot}/$id');
    if (response.statusCode == 200)
      return Track.fromMap(jsonDecode(response.body));
    return null;
  }
}
