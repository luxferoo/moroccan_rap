import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'circle_clipper.dart';

class BottomControls extends StatefulWidget {
  const BottomControls({
    Key key,
  }) : super(key: key);

  @override
  BottomControlsState createState() => BottomControlsState();
}

class BottomControlsState extends State<BottomControls> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: '',
              children: [
                TextSpan(
                    text: 'Song Title\n',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                        height: 1.5)),
                TextSpan(
                    text: 'Artist Name',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.0,
                        height: 1.5)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                AudioPlaylistComponent(
                  playlistBuilder:
                      (BuildContext context, Playlist playlist, Widget child) {
                    return IconButton(
                      iconSize: 35.0,
                      color: Colors.white,
                      onPressed: playlist.previous,
                      icon: Icon(Icons.skip_previous),
                    );
                  },
                ),
                _buildPausePlayButton(),
                AudioPlaylistComponent(
                  playlistBuilder:
                      (BuildContext context, Playlist playlist, Widget child) {
                    return IconButton(
                      iconSize: 35.0,
                      color: Colors.white,
                      onPressed: playlist.next,
                      icon: Icon(Icons.skip_next),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AudioComponent _buildPausePlayButton() {
    return AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayerState,
        WatchableAudioProperties.audioSeeking,
        WatchableAudioProperties.audioBuffering,
        WatchableAudioProperties.audioPlayhead,
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        IconData icon = Icons.all_inclusive;
        Color buttonColor = Colors.white.withOpacity(0.75);
        Function onPressed;
        if (player.state == AudioPlayerState.playing) {
          icon = Icons.pause;
          onPressed = () {
            player.pause();
          };
          buttonColor = Colors.white;
        } else if (player.state == AudioPlayerState.paused ||
            player.state == AudioPlayerState.completed) {
          icon = Icons.play_arrow;
          onPressed = () {
            player.play();
          };
          buttonColor = Colors.white;
        }

        return ClipOval(
          clipper: CircleClipper(),
          child: FlatButton(
            padding: EdgeInsets.all(15),
            child: Icon(
              icon,
              color: Theme.of(context).accentColor,
            ),
            color: buttonColor,
            splashColor: Theme.of(context).accentColor,
            highlightColor: Colors.white.withOpacity(0.75),
            onPressed: onPressed,
          ),
        );
      },
    );
  }
}
