import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/track.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;

  TrackTile({@required this.track, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colors.white,
      child: ListTile(
        leading: CachedNetworkImage(
          height: 50,
          width: 50,
          fit: BoxFit.cover,
          imageUrl: track.picture??"",
        ),
        title: Text(track.name ?? ""),
        subtitle: Text(track.album ?? ""),
        trailing: Text(
          track.duration??"00:00",
          style: TextStyle(color: Colors.grey),
        ),
        onTap: onTap,
      ),
    );
  }
}
