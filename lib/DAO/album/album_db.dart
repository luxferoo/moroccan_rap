import '../../models/album.dart';

class AlbumDb {
  Future<List<int>> fetchIds() async {
    return [1];
  }

  Future<Album> fetchItem(int id) async {
    return Album.fromMap({"name":"Album name"});
  }
}
