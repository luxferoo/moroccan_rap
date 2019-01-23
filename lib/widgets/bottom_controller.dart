import 'package:flutter/material.dart';
import 'circle_clipper.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      padding: EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: '',
              children: [
                TextSpan(
                    text: 'Song Title\n',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                        height: 1.5)),
                TextSpan(
                    text: 'Artist Name',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.0,
                        height: 1.5)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  iconSize: 35.0,
                  color: Colors.white,
                  onPressed: () {},
                  icon: Icon(Icons.skip_previous),
                ),
                ClipOval(
                  clipper: CircleClipper(),
                  child: FlatButton(
                    padding: EdgeInsets.all(15),
                    child: Icon(
                      Icons.pause,
                      color: Theme.of(context).accentColor,
                    ),
                    color: Colors.white,
                    splashColor: Theme.of(context).accentColor,
                    highlightColor: Colors.white.withOpacity(0.75),
                    onPressed: () {},
                  ),
                ),
                IconButton(
                  iconSize: 35.0,
                  color: Colors.white,
                  onPressed: () {},
                  icon: Icon(Icons.skip_next),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
