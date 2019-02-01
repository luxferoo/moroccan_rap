import 'package:rxdart/rxdart.dart';
import '../models/artist.dart' as ArtistModel;
import '../repositories/artist.dart' as ArtistRepo;

class ArtistBloc {
  final _repository = ArtistRepo.Artist();
  final _artistFetcher = PublishSubject<int>();
  final _artistIds = PublishSubject<List<int>>();
  final _artistOutput = BehaviorSubject<Map<int, Future<ArtistModel.Artist>>>();

  Observable<List<int>> get artistIds => _artistIds.stream;

  Observable<Map<int, Future<ArtistModel.Artist>>> get artist =>
      _artistOutput.stream;

  Function(int) get fetchArtist => _artistFetcher.sink.add;

  ArtistBloc() {
    _artistFetcher.stream.transform(_artistTransformer()).pipe(_artistOutput);
  }

  _artistTransformer() {
    return ScanStreamTransformer(
        (Map<int, Future<ArtistModel.Artist>> cache, int id, int index) {
      cache[id] = _repository.fetchArtist(id);
      return cache;
    }, <int, Future<ArtistModel.Artist>>{});
  }

  fetchArtistsIds() async {
    final ids = await _repository.fetchIds();
    _artistIds.sink.add(ids);
  }

  dispose() {
    _artistIds.close();
    _artistFetcher.close();
    _artistOutput.close();
  }
}
