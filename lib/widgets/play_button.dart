import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  final Function onPressed;

  const PlayButton({@required this.onPressed}) : assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 35.0,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        gradient: new LinearGradient(
          colors: [
            Colors.blueAccent,
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
          ],
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
        ),
      ),
      child: new FlatButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Play",
                style: TextStyle(color: Colors.white),
              )
            ]),
        onPressed: onPressed,
      ),
    );
  }
}
