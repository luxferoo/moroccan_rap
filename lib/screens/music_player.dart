import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import '../widgets/audio_radial_seek_bar.dart';
import '../widgets/bottom_controller.dart';

class MusicPlayer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return AudioComponent(playerBuilder:
        (BuildContext context, AudioPlayer player, Widget child) {
      return WillPopScope(
          onWillPop: () async {
            player.dispose();
            player.pause();
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter:
                        ColorFilter.mode(Colors.black87, BlendMode.darken),
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        "http://qgprod.com/wp-content/uploads/2013/10/shayfeen-ep-.jpg")),
              ),
              child: Column(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    leading: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        color: Colors.white,
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          player.dispose();
                          player.pause();
                          Navigator.of(context).pop();
                        }),
                  ),
                  Expanded(
                    child: AudioRadialSeekBar(),
                  ),
                  BottomControls()
                ],
              ),
            ),
          ));
    });
  }
}
