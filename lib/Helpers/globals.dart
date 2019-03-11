class Globals {
  static final Globals _singleton = new Globals._internal();

  factory Globals() {
    return _singleton;
  }

  String tracksRoot = 'http://www.imamharir.com/api/tracks';
  String artistsRoot = 'http://www.imamharir.com/api/artists';
  String serverPath = 'http://www.imamharir.com/';
  String trackStreamPath = 'http://www.imamharir.com/stream/';
  String appKey = 'oF52iOAQNd63Lg9GP5zQkmntmwB1Nf6m';

  Globals._internal();
}
