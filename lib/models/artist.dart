class Artist {
  final int id;
  final String picture;
  final String name;
  final String type;
  final bool liked;

  Artist.fromMap(Map<String, dynamic> parsedJson)
      : id = parsedJson["id"],
        picture = parsedJson["picture"],
        name = parsedJson["name"],
        type = parsedJson["type"],
        liked = parsedJson["liked"];
}
