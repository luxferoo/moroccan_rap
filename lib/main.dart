import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'blocs/artist_provider.dart';
import 'blocs/track_provider.dart';
import 'screens/my_navigator.dart';
import 'screens/artist_detail.dart';
import 'screens/music_player.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TrackProvider(
      child: ArtistProvider(
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: "Montserrat Regular",
            primaryColor: Colors.red,
            accentColor: Colors.red.withOpacity(0.65)
          ),
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

      return MusicPlayer();

      if (setting.name == "/") {
        trackBloc.fetchLastTracksIds();
        artistBloc.fetchArtistsIds();
        //return MyNavigator();
        return Home();
      }

      final artistDetailsRegex = RegExp(r"/artist_details/[0-9]*$");
      if (artistDetailsRegex.hasMatch(setting.name)){
        final artistId = int.parse(setting.name.replaceFirst('/artist_details/', ''));
        artistBloc.fetchArtist(artistId);
        return ArtistDetail(artistId: artistId,);
      }
    },
  );
}
