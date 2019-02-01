import 'package:meta/meta.dart';

class Track {
  @required final int id;
  @required final int artistId;
  @required final String album;
  @required final String name;
  @required final String artistName;
  @required final String picture;
  @required final String artistPicture;
  @required final String link ;
  @required final String duration ;

  Track.fromMap(Map<String, dynamic> parsedJson)
      : id = parsedJson["id"],
        artistId = parsedJson["artistId"],
        album = parsedJson["album"],
        name = parsedJson["name"],
        artistName = parsedJson["artistName"],
        picture = parsedJson["picture"],
        artistPicture = parsedJson["artistPicture"],
        link = parsedJson["link"],
        duration = parsedJson["duration"];
}
