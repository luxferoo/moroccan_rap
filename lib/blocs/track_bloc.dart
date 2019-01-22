import 'package:rxdart/rxdart.dart';
import '../models/track.dart' as TrackModel;
import '../repositories/track.dart' as TrackRepo;

class TrackBloc {
  final _repository = TrackRepo.Track();
  final _trackFetcher = PublishSubject<int>();
  final _tracksByArtistFetcher = PublishSubject<int>();
  final _tracksByArtistOutput =
      PublishSubject<Future<List<TrackModel.Track>>>();
  final _lastTracksIds = PublishSubject<List<int>>();
  final _trackOutput = BehaviorSubject<Map<int, Future<TrackModel.Track>>>();

  Observable<List<int>> get lastTracksIds => _lastTracksIds.stream;

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
      cache[id] = _repository.fetchItem(id);
      return cache;
    }, <int, Future<TrackModel.Track>>{});
  }

  fetchLastTracksIds() async {
    final ids = await _repository.fetchLastIds();
    _lastTracksIds.sink.add(ids);
  }

  dispose() {
    _tracksByArtistFetcher.close();
    _tracksByArtistOutput.close();
    _lastTracksIds.close();
    _trackFetcher.close();
    _trackOutput.close();
  }
}
