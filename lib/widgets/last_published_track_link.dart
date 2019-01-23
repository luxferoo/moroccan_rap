import 'package:flutter/material.dart';
import '../blocs/track_provider.dart';
import '../models/track.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Helpers/string.dart';

class LastPublishedTrackLink extends StatelessWidget {
  final int trackId;

  LastPublishedTrackLink({this.trackId});

  @override
  Widget build(BuildContext context) {
    TrackBloc bloc = TrackProvider.of(context);

    return StreamBuilder(
      stream: bloc.track,
      builder: (BuildContext context,
          AsyncSnapshot<Map<int, Future<Track>>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return FutureBuilder(
          future: snapshot.data[trackId],
          builder: (BuildContext context, AsyncSnapshot<Track> trackSnapshot) {
            if (!trackSnapshot.hasData) {
              return Container();
            }
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CachedNetworkImage(
                    height: 150,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                    imageUrl: trackSnapshot.data.picture,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      cropText(capitalize(trackSnapshot.data.name), 10),
                      style: TextStyle(fontSize: 20, letterSpacing: 3.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      cropText(capitalize(trackSnapshot.data.artistName), 12),
                      style: TextStyle(
                          color: Colors.grey, fontSize: 14, letterSpacing: 1.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 50, left: 50),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Play",
                              style: TextStyle(color: Colors.white),
                            )
                          ]),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
