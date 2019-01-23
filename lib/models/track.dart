import 'album.dart';

class Track {
  final int id;
  final int trackId;
  final int artistId;
  final Album album;
  final String name;
  final String artistName;
  final String picture;
  final String trackLink ;

  Track.fromMap(Map<String, dynamic> parsedJson)
      : id = parsedJson["id"],
        trackId = parsedJson["trackId"],
        artistId = parsedJson["artistId"],
        album = parsedJson["album"],
        name = parsedJson["name"],
        artistName = parsedJson["artistName"],
        picture = parsedJson["picture"],
        trackLink = parsedJson["trackLink"];
}
