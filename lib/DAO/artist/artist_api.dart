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
                  "https://scontent.fcmn2-1.fna.fbcdn.net/v/t1.0-9/12359965_1537535693223879_2806028389647671228_n.jpg?_nc_cat=110&_nc_ht=scontent.fcmn2-1.fna&oh=e7fe5f7c03cf5d6ab8e730d8d74a7616&oe=5CB52F56",
              "name": "Pause Flow",
              "type": "solo"
            },
          ),
    );
  }
}
