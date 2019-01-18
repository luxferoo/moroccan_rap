import '../../models/artist.dart';

class ArtistDb {
  Future<List<int>> fetchIds() async {
    return [1];
  }

  Future<Artist> fetchItem(int id) async {
    return Artist.fromMap({
      "id": 1,
      "picture":
      "https://cdn.nrjmaroc.com/images/artists/dizzy-dros1513958560.png",
      "name": "Dizzy Dros",
      "type": "solo"
    });
  }
}
