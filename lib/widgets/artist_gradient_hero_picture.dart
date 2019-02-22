import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../Helpers/globals.dart';
import '../models/artist.dart';

class ArtistGradientHeroPicture extends StatelessWidget {
  final Artist artist;
  final globals = Globals();

  ArtistGradientHeroPicture({@required this.artist}) : assert(artist != null);

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
        child: CachedNetworkImage(
          httpHeaders: {"app_key": globals.appKey},
          imageUrl: globals.serverPath + (artist.picture ?? ""),
          fit: BoxFit.cover,
          errorWidget:
              Image(image: AssetImage("assets/img/picture-placeholder.png")),
        ),
      ),
    );
  }
}
