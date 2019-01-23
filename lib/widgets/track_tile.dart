import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/track.dart';

class TrackTile extends StatelessWidget {
  final Track track;

  TrackTile({@required this.track});

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colors.white,
      child: ListTile(
        leading: CachedNetworkImage(
          height: 50,
          width: 50,
          fit: BoxFit.cover,
          imageUrl: track.picture,
        ),
        title: Text(track.name ?? "undefined"),
        subtitle: Text(track.album?.name ?? "undefined"),
        trailing: Text(
          "3:25",
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {},
      ),
    );
  }
}
