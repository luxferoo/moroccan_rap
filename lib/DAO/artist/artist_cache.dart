import '../../models/artist.dart';

abstract class ArtistCache {
  addArtist(Artist artist);

  Future<int> clear();
}