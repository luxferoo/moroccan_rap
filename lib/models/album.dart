class Album {
  final int id;
  final int albumId;
  final String name;

  Album.fromMap(Map<String, dynamic> parsedJson)
      : id = parsedJson["id"],
        albumId = parsedJson["albumId"],
        name = parsedJson["name"];
}
