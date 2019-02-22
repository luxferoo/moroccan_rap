import 'dart:convert';
import 'artist_source.dart';
import '../../models/artist.dart';
import 'package:http/http.dart' show Client;
import '../../Helpers/globals.dart';

class ArtistApi implements ArtistSource {
  final Globals globals = Globals();
  final _client = Client();

  Future<List<int>> fetchIds() async {
    final response = await _client.get('${globals.artistsRoot}/ids',
        headers: {"app_key": globals.appKey});
    if (response.statusCode == 200)
      return jsonDecode(response.body).cast<int>();
    return null;
  }

  Future<Artist> fetchArtist(int id) async {
    final response = await _client.get('${globals.artistsRoot}/$id',
        headers: {"app_key": globals.appKey});
    if (response.statusCode == 200)
      return Artist.fromMap(jsonDecode(response.body));
    return null;
  }
}
