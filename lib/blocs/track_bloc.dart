import 'package:rxdart/rxdart.dart';
import '../models/track.dart' as TrackModel;
import '../repositories/track.dart' as TrackRepo;

class TrackBloc {
  final _repository = TrackRepo.Track();
  final _trackFetcher = PublishSubject<int>();
  final _tracksByArtistFetcher = PublishSubject<int>();
  final _tracksByArtistOutput = ReplaySubject<Future<List<TrackModel.Track>>>();
  final _playlist = BehaviorSubject<List<TrackModel.Track>>();
  final _trackOutput = BehaviorSubject<Map<int, Future<TrackModel.Track>>>();

  Observable<List<TrackModel.Track>> get playlist => _playlist.stream;

  Observable<Map<int, Future<TrackModel.Track>>> get track =>
      _trackOutput.stream;

  Observable<Future<List<TrackModel.Track>>> get tracksByArtists =>
      _tracksByArtistOutput.stream;

  Function(int) get fetchTrack => _trackFetcher.sink.add;

  Function(int) get fetchTracksByArtist => _tracksByArtistFetcher.sink.add;

  TrackBloc() {
    _tracksByArtistFetcher.stream
        .transform(_tracksByArtistTransformer())
        .pipe(_tracksByArtistOutput);
    _trackFetcher.stream.transform(_trackTransformer()).pipe(_trackOutput);
  }

  _tracksByArtistTransformer() {
    return ScanStreamTransformer(
        (Future<List<TrackModel.Track>> result, int id, _) {
      return _repository.fetchTracksByArtistId(id);
    });
  }

  _trackTransformer() {
    return ScanStreamTransformer(
        (Map<int, Future<TrackModel.Track>> cache, int id, int index) {
      cache[id] = _repository.fetchTrack(id);
      return cache;
    }, <int, Future<TrackModel.Track>>{});
  }

  fetchLastTracks() async {
    final tracks = await _repository.fetchLastTracks();
    _playlist.sink.add(tracks);
  }

  fetchArtistPlaylist(int artistId) async {
    final tracks = await _repository.fetchTracksByArtistId(artistId);
    _playlist.sink.add(tracks);
  }

  dispose() {
    _tracksByArtistFetcher.close();
    _tracksByArtistOutput.close();
    _trackFetcher.close();
    _playlist.close();
    _trackOutput.close();
  }
}
