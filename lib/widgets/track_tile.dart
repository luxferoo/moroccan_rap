import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/track.dart';
import '../Helpers/globals.dart';

class TrackTile extends StatelessWidget {
  final Globals globals = Globals();
  final Track track;
  final VoidCallback onTap;

  TrackTile({@required this.track, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colors.white,
      child: ListTile(
        leading: CachedNetworkImage(
          errorWidget: Image(
            height: 50,
            width: 50,
            image: AssetImage("assets/img/picture-placeholder.png"),
          ),
          height: 50,
          width: 50,
          fit: BoxFit.cover,
          imageUrl: globals.serverPath+(track.picture??""),
        ),
        title: Text(track.name ?? ""),
        subtitle: Text(track.albumName ?? ""),
        onTap: onTap,
      ),
    );
  }
}
