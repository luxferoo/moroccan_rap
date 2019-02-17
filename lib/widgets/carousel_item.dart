import 'package:flutter/material.dart';
import '../widgets/play_button.dart';

class CarouselItem extends StatelessWidget {
  final picture;
  final trackName;
  final trackId;
  final artistName;

  CarouselItem({
    @required this.trackId,
    @required this.trackName,
    @required this.artistName,
    @required this.picture,
  })  : assert(trackId > 0),
        assert(trackName != null),
        assert(trackName != null),
        assert(trackName != null);

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        new DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              end: Alignment(0.0, -1.0),
              begin: Alignment(0.0, 1.0),
              colors: <Color>[
                Colors.black,
                Colors.transparent,
              ],
            ),
          ),
          child: new Image.network(
            picture,
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
                onPressed: () {},
              )
            ],
          ),
        ),
      ],
    );
  }
}
