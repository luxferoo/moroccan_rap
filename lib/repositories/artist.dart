import '../DAO/artist/artist_api.dart';
import '../DAO/artist/artist_db.dart';
import '../models/artist.dart' as ArtistModel;

class Artist {
  final ArtistApi artistApi  = ArtistApi();

  Future<List<int>> fetchIds() {
    return artistApi.fetchIds();
  }

  Future<ArtistModel.Artist> fetchItem(int id) async {
    return artistApi.fetchItem(id);
  }

  clearCache() async {
    return true;
  }
}