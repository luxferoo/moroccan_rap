import 'package:flutter/material.dart';
import 'artist_bloc.dart';
export 'artist_bloc.dart';

class ArtistProvider extends InheritedWidget {
  final ArtistBloc bloc;

  ArtistProvider({Key key, Widget child})
      : bloc = ArtistBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ArtistBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ArtistProvider)
    as ArtistProvider)
        .bloc;
  }
}
