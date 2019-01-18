import 'package:flutter/material.dart';
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
      if (setting.name == "/") {
        final ArtistBloc artistBloc = ArtistProvider.of(context);
        final TrackBloc trackBloc = TrackProvider.of(context);
        artistBloc.fetchArtistsIds();
        trackBloc.fetchLastTracksIds();
        return MyNavigator();
      }
      return ArtistDetail();
    },
  );
}
