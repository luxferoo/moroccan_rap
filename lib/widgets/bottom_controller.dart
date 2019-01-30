import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'circle_clipper.dart';

class BottomControls extends StatefulWidget {
  final String songTitle;
  final String artistName;

  BottomControls({
    this.songTitle,
    this.artistName,
  });

  @override
  BottomControlsState createState() => BottomControlsState();
}

class BottomControlsState extends State<BottomControls> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black26,
          Colors.black,
          Colors.black,
        ],
      )),
      padding: EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '',
              children: [
                TextSpan(
                    text: widget.songTitle + "\n",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                        height: 1.5)),
                TextSpan(
                    text: widget.artistName,
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
    ClipOval _buildCircularControlButton(
        {VoidCallback onPressed, IconData icon}) {
      return ClipOval(
        clipper: CircleClipper(),
        child: FlatButton(
          padding: EdgeInsets.all(15),
          child: Icon(
            icon,
            color: Theme.of(context).accentColor,
          ),
          color: Colors.white,
          splashColor: Theme.of(context).accentColor,
          highlightColor: Colors.white.withOpacity(0.75),
          onPressed: onPressed,
        ),
      );
    }

    return AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayerState,
        WatchableAudioProperties.audioSeeking,
        WatchableAudioProperties.audioBuffering,
        WatchableAudioProperties.audioPlayhead,
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        if (player.state == AudioPlayerState.playing) {
          return _buildCircularControlButton(
              icon: Icons.pause, onPressed: player.pause);
        } else if (player.state == AudioPlayerState.paused ||
            player.state == AudioPlayerState.completed) {
          return _buildCircularControlButton(
              icon: Icons.play_arrow, onPressed: player.play);
        } else {
          return Padding(
              padding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 1.0),
              child: Text(
                "Buffering...",
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ));
        }
      },
    );
  }
}
