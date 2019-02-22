import 'package:flutter/material.dart';
import '../widgets/play_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Helpers/globals.dart';

class CarouselItem extends StatelessWidget {
  final String picture;
  final String trackName;
  final int trackId;
  final String artistName;
  final Function onPressed;
  final globals = new Globals();

  CarouselItem({
    @required this.trackId,
    @required this.trackName,
    @required this.artistName,
    @required this.picture,
    @required this.onPressed,
  })  : assert(trackId > 0),
        assert(trackName != null),
        assert(trackId != null),
        assert(artistName != null),
        assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        new DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment(0.0, -1.0),
              end: Alignment(0.0, 1.0),
              colors: <Color>[
                Colors.transparent,
                Colors.black,
              ],
            ),
          ),
          child: new CachedNetworkImage(
            httpHeaders: {"app_key": globals.appKey},
            imageUrl: picture,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        new Padding(
          padding: new EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text.rich(
                new TextSpan(
                  text: trackName + "\n",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    new TextSpan(
                      text: artistName,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PlayButton(
                onPressed: onPressed,
              )
            ],
          ),
        ),
      ],
    );
  }
}
