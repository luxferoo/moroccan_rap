class Track {
  final int id;
  final int trackId;
  final int artistId;
  final String album;
  final String name;
  final String artistName;
  final String picture;
  final String artistPicture;
  final String link ;
  final String duration ;

  Track.fromMap(Map<String, dynamic> parsedJson)
      : id = parsedJson["id"],
        trackId = parsedJson["trackId"],
        artistId = parsedJson["artistId"],
        album = parsedJson["album"],
        name = parsedJson["name"],
        artistName = parsedJson["artistName"],
        picture = parsedJson["picture"],
        artistPicture = parsedJson["artistPicture"],
        link = parsedJson["link"],
        duration = parsedJson["duration"];
}
