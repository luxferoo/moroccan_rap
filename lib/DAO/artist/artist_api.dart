import '../../models/artist.dart';
import 'dart:math' as math;

class ArtistApi {
  Future<List<int>> fetchIds() async {
    return [1, 2, 3, 4, 5, 56, 7, 8, 9, 10];
  }

  Future<Artist> fetchItem(int id) async {
    return await Future.delayed(
      Duration(seconds: math.Random().nextInt(3)),
      () => Artist.fromMap(
            {
              "id": id,
              "picture":
                  "http://qgprod.com/wp-content/uploads/2013/10/shayfeen-ep-.jpg",
              "name": "Shayfeen",
              "type": "Crew"
            },
          ),
    );
  }
}
