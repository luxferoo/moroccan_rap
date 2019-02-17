import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Helpers/string.dart';
import '../Helpers/globals.dart';
import '../widgets/play_button.dart';

class LastPublishedTrackLink extends StatelessWidget {
  final Globals globals = Globals();
  final VoidCallback onPressed;
  @required
  final String picture;
  @required
  final String name;
  @required
  final String artistName;

  LastPublishedTrackLink(
      {this.picture, this.name, this.artistName, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CachedNetworkImage(
            errorWidget: Image(
              image: AssetImage("assets/img/picture-placeholder.png"),
            ),
            height: 120,
            width: double.maxFinite,
            fit: BoxFit.cover,
            imageUrl: globals.serverPath + (picture ?? ""),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              cropText(capitalize(name ?? ""), 10),
              style: TextStyle(fontSize: 15, letterSpacing: 3.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              cropText(capitalize(artistName ?? ""), 12),
              style: TextStyle(
                  color: Colors.grey, fontSize: 13, letterSpacing: 1.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, right: 30, left: 30),
            child: PlayButton(onPressed: onPressed),
          ),
        ],
      ),
    );
  }
}
