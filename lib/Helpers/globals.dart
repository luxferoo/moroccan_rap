class Globals {
  static final Globals _singleton = new Globals._internal();

  factory Globals() {
    return _singleton;
  }

  String tracksRoot = 'http://192.168.77.143:4000/api/tracks';
  String artistsRoot = 'http://192.168.77.143:4000/api/artists';
  String serverPath = 'http://192.168.77.143:4000/';

  Globals._internal();
}
