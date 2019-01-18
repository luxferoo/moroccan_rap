import 'package:flutter/material.dart';
import '../models/artist.dart';

class ArtistGradientHeroPicture extends StatelessWidget {
  final Artist artist;

  ArtistGradientHeroPicture({@required this.artist});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "${artist.id}-picture",
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment(0.0, 1.2),
            end: Alignment(0.0, -0.5),
            colors: <Color>[Colors.black, Colors.transparent],
          ),
        ),
        child: Image.network(
          artist.picture,
          colorBlendMode: BlendMode.darken,
          fit: BoxFit.cover,
          height: 5000,
          width: 5000,
        ),
      ),
    );
  }
}
