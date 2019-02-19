import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
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
              brightness: Brightness.dark,
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
        return SplashScreen();
      }

      if (setting.name == "/home") {
        trackBloc.fetchRecentTracks();
        artistBloc.fetchArtistsIds();
        trackBloc.fetchCarouselPlaylist();
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

      List<String> splitted = setting.name.split("/");
      print(splitted);
      if (splitted[1] == "player") {
        String subRoute = splitted[2];
        int index = int.parse(splitted[3]);
        switch (subRoute) {
          case "recent":
            return MusicPlayer(
              startAt: index,
              playlistStreamSource: trackBloc.recentTracksPlaylist,
            );
            break;
          case "artist":
            return MusicPlayer(
              startAt: index,
              playlistStreamSource: trackBloc.artistPlaylist,
            );
            break;
          case "carousel":
            return MusicPlayer(
              startAt: index,
              playlistStreamSource: trackBloc.carouselPlaylist,
            );
            break;
        }
      }
    },
  );
}
