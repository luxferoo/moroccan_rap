import '../../models/artist.dart';

abstract class ArtistSource {
  Future<List<int>> fetchIds();

  Future<Artist> fetchArtist(int id);
}