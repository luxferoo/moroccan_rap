import 'package:meta/meta.dart';

class Track {
  @required final int id;
  @required final int artistId;
  @required final String albumName;
  @required final String name;
  @required final String artistName;
  @required final String picture;
  @required final String artistPicture;
  @required final String track ;
  @required final String duration ;

  Track.fromMap(Map<String, dynamic> parsedJson)
      : id = parsedJson["id"],
        artistId = parsedJson["artistId"],
        albumName = parsedJson["albumName"],
        name = parsedJson["name"],
        artistName = parsedJson["artistName"],
        picture = parsedJson["picture"],
        artistPicture = parsedJson["artistPicture"],
        track = parsedJson["track"],
        duration = parsedJson["duration"];
}
