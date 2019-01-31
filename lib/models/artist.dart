import 'package:meta/meta.dart';

class Artist {
  @required final int id;
  @required final String picture;
  @required final String name;
  @required final String type;

  Artist.fromMap(Map<String, dynamic> parsedJson)
      : id = parsedJson["id"],
        picture = parsedJson["picture"],
        name = parsedJson["name"],
        type = parsedJson["type"];
}
