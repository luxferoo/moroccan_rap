import '../DAO/track/track_api.dart';
import '../DAO/track/track_db.dart';
import '../DAO/track/track_source.dart';
import '../DAO/track/track_cache.dart';
import '../models/track.dart' as TrackModel;

class Track {
  final TrackApi trackApi = TrackApi();

  List<TrackSource> sources = <TrackSource>[
    TrackDb(),
    TrackApi(),
  ];

  List<TrackCache> caches = <TrackCache>[
    TrackDb(),
  ];

  Future<List<int>> fetchLastIds() {
    return trackApi.fetchLastIds();
  }

  Future<List<TrackModel.Track>> fetchTracksByArtistId(int id) async {
    List<TrackModel.Track> trackList;
    TrackSource source;
    TrackCache cache;

    for (source in sources) {
      trackList = await source.fetchTracksByArtistId(id);
      if (trackList != null) {
        break;
      }
    }

    for (cache in caches) {
      if ((cache as TrackSource) != source) {
        trackList.forEach((track) {
          cache.addTrack(track);
        });
      }
    }

    return trackList;
  }

  Future<TrackModel.Track> fetchTrack(int id) async {
    TrackModel.Track track;
    TrackSource source;
    TrackCache cache;

    for (source in sources) {
      track = await source.fetchTrack(id);
      if (track != null) {
        break;
      }
    }

    for (cache in caches) {
      if ((cache as TrackSource) != source) {
        cache.addTrack(track);
      }
    }

    return track;
  }

  Future<List<TrackModel.Track>> fetchLastTracks() {
    return trackApi.fetchLastTracks();
  }

  clearCache() async {
    for (var cache in caches) {
      await cache.clear();
    }
  }
}
