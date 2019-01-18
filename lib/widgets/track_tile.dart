import 'package:flutter/material.dart';
import '../models/track.dart';

class TrackTile extends StatelessWidget {
  final Track track;

  TrackTile({@required this.track});

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colors.white,
      child: ListTile(
        title: Text(track.name ?? "undefined"),
        subtitle: Text(track.album?.name?? "undefined"),
        trailing: Text(
          "3:25",
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {},
        onLongPress: () {
          final scaffold = Scaffold.of(context);
          scaffold.showSnackBar(
            SnackBar(
              content: const Text('Added to favorite'),
              action: SnackBarAction(
                  textColor: Colors.white,
                  label: 'Close',
                  onPressed: scaffold.hideCurrentSnackBar),
            ),
          );
        },
      ),
    );
  }
}
