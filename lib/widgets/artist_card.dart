import 'package:flutter/material.dart';
import 'artist_gradient_hero_picture.dart';
import '../blocs/artist_provider.dart';
import '../models/artist.dart';
import 'dart:math';

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
          return Card();
        }

        return FutureBuilder(
          future: snapshot.data[artistId],
          builder:
              (BuildContext context, AsyncSnapshot<Artist> artistSnapshot) {
            if (!artistSnapshot.hasData) {
              return Card();
            }
            return Card(
              child: InkWell(
                child: Container(
                  height: height,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ArtistGradientHeroPicture(artist: artistSnapshot.data,),
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
      title: Hero(
        tag: "${artist.id}-name",
        child: Material(
          color: Colors.transparent,
          child: Text(
            artist.name,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ),
      subtitle: Text(
        artist.type,
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.white),
      ),
      trailing: FloatingActionButton(
        heroTag: "${artist.id}-favorite",
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        onPressed: () {},
        child: Icon(
          Icons.favorite,
          color: Colors.red,
        ),
      ),
    );
  }
}
