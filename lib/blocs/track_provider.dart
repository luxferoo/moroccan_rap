import 'package:flutter/material.dart';
import 'track_bloc.dart';
export 'track_bloc.dart';

class TrackProvider extends InheritedWidget {
  final TrackBloc bloc;

  TrackProvider({Key key, Widget child})
      : bloc = TrackBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static TrackBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(TrackProvider)
    as TrackProvider)
        .bloc;
  }
}
