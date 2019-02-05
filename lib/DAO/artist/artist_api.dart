import 'dart:convert';
import 'artist_source.dart';
import '../../models/artist.dart';
import 'package:http/http.dart' show Client;
import '../../Helpers/globals.dart';

class ArtistApi implements ArtistSource {
  final globals = Globals();
  final _client = Client();

  Future<List<int>> fetchIds() async {
    final response = await _client.get('${globals.artistsRoot}/ids');
    if (response.statusCode == 200)
      return jsonDecode(response.body).cast<int>();
    return null;
  }

  Future<Artist> fetchArtist(int id) async {
    final response = await _client.get('${globals.artistsRoot}/$id');
    if (response.statusCode == 200)
      return Artist.fromMap(jsonDecode(response.body));
    return null;
  }
}
