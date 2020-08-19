class Globals {
  static final Globals _singleton = new Globals._internal();

  factory Globals() {
    return _singleton;
  }

  String tracksRoot = 'http://www.imamharir.com/api/tracks';
  String artistsRoot = 'http://www.imamharir.com/api/artists';
  String serverPath = 'http://www.imamharir.com/';
  String trackStreamPath = 'http://www.imamharir.com/stream/';
  String appKey = 'your_app_key';

  Globals._internal();
}
