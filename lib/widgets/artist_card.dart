import 'package:flutter/material.dart';
import 'artist_gradient_hero_picture.dart';
import '../blocs/artist_provider.dart';
import '../models/artist.dart';

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
              margin: EdgeInsets.all(5.0),
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
        artist.name,
        style: TextStyle(color: Colors.white, fontSize: 13.0,fontWeight: FontWeight.bold),
        overflow: TextOverflow.clip,
      ),
      subtitle: Text(
        artist.type,
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.red, fontSize: 13.0),
      ),
      trailing: InkWell(
        child: Transform.scale(
            scale: 0.8,
            child: Hero(
              tag: "${artist.id}-favorite",
              child: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            )),
        onTap: () {},
      ),
    );
  }
}
