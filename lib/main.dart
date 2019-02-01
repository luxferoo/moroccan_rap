import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home.dart';
import 'blocs/artist_provider.dart';
import 'blocs/track_provider.dart';
import 'screens/artist_detail.dart';
import 'screens/music_player.dart';
import 'Helpers/db_provider.dart';

void main() async {
  await dbProvider.init();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));

    return TrackProvider(
      child: ArtistProvider(
        child: MaterialApp(
          theme: ThemeData(
              fontFamily: "Montserrat Regular",
              primaryColor: Colors.deepPurple,
              accentColor: Colors.deepPurpleAccent),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: routes,
        ),
      ),
    );
  }
}

MaterialPageRoute routes(RouteSettings setting) {
  return MaterialPageRoute(
    builder: (BuildContext context) {
      final ArtistBloc artistBloc = ArtistProvider.of(context);
      final TrackBloc trackBloc = TrackProvider.of(context);

      if (setting.name == "/") {
        trackBloc.fetchLastTracksIds();
        artistBloc.fetchArtistsIds();
        return Home();
      }

      final artistDetailsRegex = RegExp(r"/artist_details/[0-9]*$");
      if (artistDetailsRegex.hasMatch(setting.name)) {
        final artistId =
            int.parse(setting.name.replaceFirst('/artist_details/', ''));
        artistBloc.fetchArtist(artistId);
        return ArtistDetail(
          artistId: artistId,
        );
      }
      final playerRegex = RegExp(r"/player/[0-9]*$");
      if (playerRegex.hasMatch(setting.name)) {
        final index = int.parse(setting.name.replaceFirst('/player/', ''));
        return MusicPlayer(startAt: index);
      }
    },
  );
}
