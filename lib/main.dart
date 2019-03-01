import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/track.dart';
import 'screens/splash_screen.dart';
import 'screens/home.dart';
import 'blocs/artist_provider.dart';
import 'blocs/track_provider.dart';
import 'screens/artist_detail.dart';
import 'screens/music_player.dart';
import 'Helpers/db_provider.dart';
import 'Helpers/globals.dart';
import 'blocs/audio_player_provider.dart';
import 'repositories/track.dart' as TrackRepos;

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

    return new TrackProvider(
      child: new ArtistProvider(
        child: new AudioPlayerProvider(
          child: new MaterialApp(
            theme: new ThemeData(
                brightness: Brightness.dark,
                fontFamily: "Montserrat Regular",
                primaryColor: Colors.deepPurple,
                accentColor: Colors.deepPurpleAccent),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: routes,
          ),
        ),
      ),
    );
  }
}

MaterialPageRoute routes(RouteSettings setting) {
  TrackRepos.Track trackRepos = new TrackRepos.Track();
  final Globals globals = new Globals();

  return new MaterialPageRoute(
    builder: (BuildContext context) {
      return new Padding(
        padding: new EdgeInsets.only(bottom: 60.0),
        child: (() {
          final ArtistBloc artistBloc = ArtistProvider.of(context);
          final TrackBloc trackBloc = TrackProvider.of(context);
          final AudioPlayerBloc audioPlayerBloc =
              AudioPlayerProvider.of(context);
          audioPlayerBloc.ping();

          if (setting.name == "/") {
            return new SplashScreen();
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
          if (splitted[1] == "player") {
            Future<List<Track>> futureTrackList;

            String subRoute = splitted[2];
            int index = int.parse(splitted[3]);
            switch (subRoute) {
              case "recent":
                futureTrackList = trackRepos.fetchRecentTracks();
                break;
              case "artist":
                futureTrackList =
                    trackRepos.fetchTracksByArtistId(int.parse(splitted[4]));
                break;
              case "carousel":
                futureTrackList = trackRepos.fetchCarouselTracks();
                break;
            }

            return new FutureBuilder(
              future: futureTrackList,
              builder: (BuildContext context, AsyncSnapshot<List<Track>> snapshot) {
                if (!snapshot.hasData) {
                  return new Scaffold(
                    backgroundColor: Colors.black,
                    body: Container(
                      color: Colors.black,
                      width: double.maxFinite,
                      height: double.maxFinite,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        leading: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            color: Colors.white,
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ),
                    ),
                  );
                } else {
                  List<Track> trackList = snapshot.data.map((track) {
                    track.track = globals.trackStreamPath + track.track;
                    return track;
                  }).toList();
                  return new MusicPlayer(
                    startAt: index,
                    trackList: trackList,
                  );
                }
              },
            );
          }
        })(),
      );
    },
  );
}
