import 'package:flutter/material.dart';
import 'audio_player_bloc.dart';
export 'audio_player_bloc.dart';

class AudioPlayerProvider extends InheritedWidget {
  final AudioPlayerBloc bloc;

  AudioPlayerProvider({Key key, Widget child})
      : bloc = AudioPlayerBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AudioPlayerBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AudioPlayerProvider)
    as AudioPlayerProvider)
        .bloc;
  }
}
