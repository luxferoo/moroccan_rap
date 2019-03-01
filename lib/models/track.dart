import 'package:meta/meta.dart';

class Track {
  @required
  int id;
  @required
  int artistId;
  @required
  String albumName;
  @required
  String name;
  @required
  String artistName;
  @required
  String picture;
  @required
  String artistPicture;
  @required
  String track;

  Track.fromMap(Map<String, dynamic> parsedJson)
      : id = parsedJson["id"],
        artistId = parsedJson["artistId"],
        albumName = parsedJson["albumName"],
        name = parsedJson["name"],
        artistName = parsedJson["artistName"],
        picture = parsedJson["picture"],
        artistPicture = parsedJson["artistPicture"],
        track = parsedJson["track"];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "artistId": artistId,
      "albumName": albumName,
      "name": name,
      "artistName": artistName,
      "picture": picture,
      "artistPicture": artistPicture,
      "track": track,
    };
  }
}
