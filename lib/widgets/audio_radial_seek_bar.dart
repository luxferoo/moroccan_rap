import 'package:flutter/material.dart';
import 'radial_seek_bar.dart';
import '../blocs/audio_player_provider.dart';

class AudioRadialSeekBar extends StatefulWidget {
  final String picture;

  const AudioRadialSeekBar({@required this.picture});

  @override
  State<StatefulWidget> createState() => _AudioRadialSeekBarState();
}

class _AudioRadialSeekBarState extends State<AudioRadialSeekBar> {
  double progress;
  int duration = 0;
  int currentPosition = 0;
  int buffering = 0;

  @override
  bool get mounted => super.mounted;

  @override
  Widget build(BuildContext context) {
    AudioPlayerBloc audioPlayerBloc = AudioPlayerProvider.of(context);

    audioPlayerBloc.duration.doOnData((data) {
      if (mounted)
        setState(() {
          duration = data;
        });
    }).listen(null);

    audioPlayerBloc.currentPosition.doOnData((data) {
      if (mounted)
        setState(() {
          currentPosition = data;
        });
    }).listen(null);

    audioPlayerBloc.bufferingValue.doOnData((data) {
      if (mounted)
        setState(() {
          buffering = data;
        });
    }).listen(null);
    if (currentPosition == 0 && duration == 0) {
      progress = 0.0;
    } else {
      progress = currentPosition / duration;
    }
    return RadialSeekBar(
      picture: widget.picture,
      progress: progress,
      onSeekRequested: (double seekPercent) {
        if (progress > 0) {
          if (seekPercent < buffering / 100) {
            audioPlayerBloc.seek((duration * seekPercent).toInt());
          }
        }
      },
    );
  }
}
