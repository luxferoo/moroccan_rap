import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'blocs/artist_provider.dart';
import 'blocs/track_provider.dart';
import 'screens/my_navigator.dart';
import 'screens/artist_detail.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TrackProvider(
      child: ArtistProvider(
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.red,
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
