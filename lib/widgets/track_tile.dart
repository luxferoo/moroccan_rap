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
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/img/waves.jpg"),
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.dstATop)),
      ),
      child: ListTile(
        leading: CachedNetworkImage(
          errorWidget: Image(
            height: 40,
            width: 40,
            image: AssetImage("assets/img/musique_icon.png"),
          ),
          placeholder: Image.asset("assets/img/musique_icon.png",
            height: 40,
            width: 40,),
          height: 40,
          width: 40,
          fit: BoxFit.cover,
          imageUrl: globals.serverPath + (track.picture ?? ""),
        ),
        title: Text(
          track.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          track.albumName ?? "",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
