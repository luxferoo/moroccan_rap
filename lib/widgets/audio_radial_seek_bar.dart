import 'package:flutter/material.dart';
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
    double playBackProgress = 0.0;
    //_seekPercent = player.isSeeking ? _seekPercent : null;
    return RadialSeekBar(
      picture: widget.picture,
      progress: playBackProgress,
      seekPercent: _seekPercent,
      onSeekRequested: (double seekPercent) {
        setState(() {
          _seekPercent = seekPercent;
        });
        /*final seekMillis =
            (player.audioLength.inMilliseconds * seekPercent).round();
        player.seek(Duration(milliseconds: seekMillis));*/
      },
    );
    ;
  }
}
