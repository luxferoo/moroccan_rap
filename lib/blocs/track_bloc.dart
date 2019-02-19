import 'package:rxdart/rxdart.dart';
import '../models/track.dart' as TrackModel;
import '../repositories/track.dart' as TrackRepo;

class TrackBloc {
  final _repository = TrackRepo.Track();
  final _trackFetcher = PublishSubject<int>();
  final _tracksByArtistFetcher = PublishSubject<int>();
  final _tracksByArtistOutput = ReplaySubject<Future<List<TrackModel.Track>>>();
  final _recentTracksPlaylist = PublishSubject<List<TrackModel.Track>>();
  final _carouselPlaylist = PublishSubject<List<TrackModel.Track>>();
  final _artistPlaylist = PublishSubject<List<TrackModel.Track>>();

  Observable<List<TrackModel.Track>> get recentTracksPlaylist => _recentTracksPlaylist.stream;
  Observable<List<TrackModel.Track>> get artistPlaylist => _artistPlaylist.stream;
  Observable<List<TrackModel.Track>> get carouselPlaylist => _carouselPlaylist.stream;

  Observable<Future<List<TrackModel.Track>>> get tracksByArtists =>
      _tracksByArtistOutput.stream;

  Function(int) get fetchTrack => _trackFetcher.sink.add;

  Function(int) get fetchTracksByArtist => _tracksByArtistFetcher.sink.add;

  TrackBloc() {
    _tracksByArtistFetcher.stream
        .transform(_tracksByArtistTransformer())
        .pipe(_tracksByArtistOutput);
  }

  _tracksByArtistTransformer() {
    return ScanStreamTransformer(
        (Future<List<TrackModel.Track>> result, int id, _) {
      return _repository.fetchTracksByArtistId(id);
    });
  }

  fetchRecentTracks() async {
    final tracks = await _repository.fetchRecentTracks();
    _recentTracksPlaylist.sink.add(tracks);
  }

  fetchArtistPlaylist(int artistId) async {
    final tracks = await _repository.fetchTracksByArtistId(artistId);
    _artistPlaylist.sink.add(tracks);
  }

  fetchCarouselPlaylist() async {
    final tracks = await _repository.fetchCarouselTracks();
    _carouselPlaylist.sink.add(tracks);
  }

  dispose() {
    _tracksByArtistFetcher.close();
    _tracksByArtistOutput.close();
    _trackFetcher.close();
    _recentTracksPlaylist.close();
    _artistPlaylist.close();
    _carouselPlaylist.close();
  }
}
