import 'package:rxdart/rxdart.dart';
import '../models/track.dart' as TrackModel;
import '../repositories/track.dart' as TrackRepo;

class TrackBloc {
  final _repository = TrackRepo.Track();
  final _trackFetcher = PublishSubject<int>();
  final _lastTracksIds = PublishSubject<List<int>>();
  final _trackOutput = BehaviorSubject<Map<int, Future<TrackModel.Track>>>();

  Observable<List<int>> get lastTracksIds => _lastTracksIds.stream;

  Observable<Map<int, Future<TrackModel.Track>>> get track =>
      _trackOutput.stream;

  Function(int) get fetchTrack => _trackFetcher.sink.add;

  TrackBloc() {
    _trackFetcher.stream.transform(_trackTransformer()).pipe(_trackOutput);
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
    _lastTracksIds.close();
    _trackFetcher.close();
    _trackOutput.close();
  }
}
