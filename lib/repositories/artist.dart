import '../DAO/artist/artist_source.dart';
import '../DAO/artist/artist_cache.dart';
import '../DAO/artist/artist_api.dart';
import '../DAO/artist/artist_db.dart';
import '../models/artist.dart' as ArtistModel;

class Artist {
  final ArtistApi artistApi  = ArtistApi();

  List<ArtistSource> sources = <ArtistSource>[
    ArtistDb(),
    ArtistApi(),
  ];

  List<ArtistCache> caches = <ArtistCache>[
    ArtistDb(),
  ];

  Future<List<int>> fetchIds() async {
    return artistApi.fetchIds();
  }

  Future<ArtistModel.Artist> fetchArtist(int id) async {
    ArtistModel.Artist artist;
    ArtistSource source;
    ArtistCache cache;

    for (source in sources) {
      artist = await source.fetchArtist(id);
      if (artist != null) {
        break;
      }
    }

    for (cache in caches) {
      if ((cache as ArtistSource) != source) {
        cache.addArtist(artist);
      }
    }

    return artist;
  }

  clearCache() async {
    for (var cache in caches) {
      await cache.clear();
    }
  }
}