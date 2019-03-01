import 'package:flutter/material.dart';
import 'circle_clipper.dart';
import '../blocs/audio_player_provider.dart';

class BottomControls extends StatefulWidget {
  final String songTitle;
  final String artistName;
  final VoidCallback onNextPressed;
  final VoidCallback onPreviousPressed;

  BottomControls({
    @required this.songTitle,
    @required this.artistName,
    @required this.onNextPressed,
    @required this.onPreviousPressed,
  })  : assert(onNextPressed != null),
        assert(onPreviousPressed != null);

  @override
  BottomControlsState createState() => BottomControlsState();
}

class BottomControlsState extends State<BottomControls> {
  @override
  Widget build(BuildContext context) {
    AudioPlayerBloc audioPlayerBloc = AudioPlayerProvider.of(context);
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
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '',
              children: [
                TextSpan(
                    text: "${widget.songTitle ?? ""}\n",
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
                new IconButton(
                  iconSize: 35.0,
                  color: Colors.white,
                  onPressed: widget.onPreviousPressed,
                  icon: Icon(Icons.skip_previous),
                ),
                _buildPausePlayButton(audioPlayerBloc),
                new IconButton(
                  iconSize: 35.0,
                  color: Colors.white,
                  onPressed: widget.onNextPressed,
                  icon: Icon(Icons.skip_next),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPausePlayButton(AudioPlayerBloc audioPlayerBloc) {
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

    return StreamBuilder(
      stream: audioPlayerBloc.playerState,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return _buildCircularControlButton(
              icon: Icons.play_arrow, onPressed: () {});
        } else if (snapshot.data == "playing") {
          return _buildCircularControlButton(
              icon: Icons.pause, onPressed: audioPlayerBloc.pause);
        } else {
          return _buildCircularControlButton(
              icon: Icons.play_arrow, onPressed: audioPlayerBloc.play);
        }
      },
    );
  }
}
