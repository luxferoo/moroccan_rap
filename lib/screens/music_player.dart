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
            backgroundColor: Colors.white,
            body: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                    Theme.of(context).primaryColor,
                  ],
                ),
              ),
              child: Column(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    leading: IconButton(
                        color: Theme.of(context).primaryColor,
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
