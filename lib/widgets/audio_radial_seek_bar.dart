import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'radial_seek_bar.dart';

class AudioRadialSeekBar extends StatefulWidget {
  final String picture;

  const AudioRadialSeekBar({@required this.picture});

  @override
  State<StatefulWidget> createState() => _AudioRadialSeekBarState();
}

class _AudioRadialSeekBarState extends State<AudioRadialSeekBar> {
  double _seekPercent;

  @override
  Widget build(BuildContext context) {
    return AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayhead,
        WatchableAudioProperties.audioSeeking,
        WatchableAudioProperties.audioPlayerState
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        double playBackProgress = 0.0;
        if (player.audioLength != null && player.position != null) {
          playBackProgress = player.position.inMilliseconds /
              player.audioLength.inMilliseconds;
        }
        _seekPercent = player.isSeeking ? _seekPercent : null;
        return RadialSeekBar(
          picture: widget.picture,
          progress: playBackProgress,
          seekPercent: _seekPercent,
          onSeekRequested: (double seekPercent) {
            final seekMillis =
                (player.audioLength.inMilliseconds * seekPercent).round();
            player.seek(Duration(milliseconds: seekMillis));
          },
        );
      },
    );
  }
}
