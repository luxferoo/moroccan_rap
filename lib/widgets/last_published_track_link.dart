import 'package:flutter/material.dart';
import '../blocs/track_provider.dart';
import '../models/track.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: trackSnapshot.data.picture,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      trackSnapshot.data.name,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
