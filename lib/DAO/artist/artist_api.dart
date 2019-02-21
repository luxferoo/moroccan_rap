import 'dart:convert';
import 'artist_source.dart';
import '../../models/artist.dart';
import 'package:http/http.dart' show Client;
import '../../Helpers/globals.dart';

class ArtistApi implements ArtistSource {
  final Globals globals = Globals();
  final _client = Client();
  final Map<String, String> headers = {
    "app_key": "oF52iOAQNd63Lg9GP5zQkmntmwB1Nf6m"
  };

  Future<List<int>> fetchIds() async {
    final response =
        await _client.get('${globals.artistsRoot}/ids', headers: headers);
    if (response.statusCode == 200)
      return jsonDecode(response.body).cast<int>();
    return null;
  }

  Future<Artist> fetchArtist(int id) async {
    final response =
        await _client.get('${globals.artistsRoot}/$id', headers: headers);
    if (response.statusCode == 200)
      return Artist.fromMap(jsonDecode(response.body));
    return null;
  }
}
