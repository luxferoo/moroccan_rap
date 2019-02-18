class Globals {
  static final Globals _singleton = new Globals._internal();

  factory Globals() {
    return _singleton;
  }

  String tracksRoot = 'http://206.189.15.19/api/tracks';
  String artistsRoot = 'http://206.189.15.19/api/artists';
  String serverPath = 'http://206.189.15.19/';
  String trackStreamPath = 'http://206.189.15.19/stream/';

  Globals._internal();
}
