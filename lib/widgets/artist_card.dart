import 'package:flutter/material.dart';
import 'artist_gradient_hero_picture.dart';
import '../blocs/artist_provider.dart';
import '../models/artist.dart';
import '../Helpers/string.dart';

class ArtistCard extends StatelessWidget {
  final VoidCallback onTap;
  final double height;
  final int artistId;

  ArtistCard({this.onTap, this.height, @required this.artistId});

  @override
  Widget build(BuildContext context) {
    ArtistBloc bloc = ArtistProvider.of(context);

    return StreamBuilder(
      stream: bloc.artist,
      builder: (BuildContext context,
          AsyncSnapshot<Map<int, Future<Artist>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return FutureBuilder(
          future: snapshot.data[artistId],
          builder:
              (BuildContext context, AsyncSnapshot<Artist> artistSnapshot) {
            if (!artistSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Container(
              margin: EdgeInsets.all(0.5),
              child: InkWell(
                child: Container(
                  height: height,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ArtistGradientHeroPicture(
                        artist: artistSnapshot.data,
                      ),
                      Container(
                          alignment: Alignment.bottomCenter,
                          child: _buildTile(artistSnapshot.data))
                    ],
                  ),
                ),
                onTap: onTap,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTile(Artist artist) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
      title: Text(
        cropText(capitalize(artist.name??""), 8),
        style: TextStyle(color: Colors.white, fontSize: 11.0,letterSpacing: 3.0),
      ),
      subtitle: Text(
        artist.type??"",
        style: TextStyle(color: Colors.white70, fontSize: 10.0),
      ),
    );
  }
}
