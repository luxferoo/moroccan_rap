import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  final Function onPressed;

  const PlayButton({@required this.onPressed}) : assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
      color: Theme.of(context).primaryColor,
      onPressed: onPressed,
    );
  }
}
