import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import '../Helpers/admob.dart';
import '../Helpers/globals.dart';
import 'package:flutter/material.dart';
import '../Helpers/string.dart';
import '../models/track.dart';
import '../widgets/audio_radial_seek_bar.dart';
import '../widgets/bottom_controller.dart';
import '../blocs/audio_player_provider.dart';

class MusicPlayer extends StatefulWidget {
  final List<Track> trackList;
  final int startAt;
  final Globals globals = new Globals();

  MusicPlayer({
    @required this.trackList,
    this.startAt = 0,
  }) : assert(trackList != null);

  @override
  _MusicPlayerState createState() => _MusicPlayerState(startAt: startAt);
}

class _MusicPlayerState extends State<MusicPlayer> {
  final Globals globals = Globals();
  int startAt;

  _MusicPlayerState({this.startAt}) {
    startAt = startAt;
  }

  @override
  Widget build(BuildContext context) {
    /myInterstitial
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
      );

    VoidCallback onNextPressed = () {
      if (startAt < widget.trackList.length - 1) {
        setState(() {
          startAt++;
          AudioPlayerProvider.of(context).previous();
        });
      }
    };

    VoidCallback onPreviousPressed = () {
      if (startAt != 0) {
        setState(() {
          startAt--;
          AudioPlayerProvider.of(context).previous();
        });
      }
    };

    AudioPlayerProvider.of(context)
        .loadAudio(tracks: widget.trackList, startAt: startAt);
    AudioPlayerProvider.of(context).setOnCompletion(cb: onNextPressed);

    return new Scaffold(
      backgroundColor: Colors.black,
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
                globals.serverPath +
                    (widget.trackList[startAt].artistPicture ?? ""),
                headers: {"app_key": globals.appKey}),
          ),
        ),
        child: Column(
          children: <Widget>[
            _buildAppBar(context),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new StreamBuilder(
                    stream: AudioPlayerProvider.of(context).currentPosition,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      int currentPosition = 0;
                      if (snapshot.hasData) {
                        currentPosition = snapshot.data;
                      }
                      return new Text(
                        formatDuration(
                            new Duration(milliseconds: currentPosition)),
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  ),
                  AudioRadialSeekBar(
                    picture: globals.serverPath +
                        (widget.trackList[startAt].picture ?? ""),
                  ),
                  new StreamBuilder(
                    stream: AudioPlayerProvider.of(context).duration,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      int duration = 0;
                      if (snapshot.hasData) {
                        duration = snapshot.data;
                      }
                      return new Text(
                        formatDuration(new Duration(milliseconds: duration)),
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  )
                ],
              ),
            ),
            BottomControls(
              songTitle: widget.trackList[startAt].name,
              artistName: widget.trackList[startAt].artistName,
              onNextPressed: onNextPressed,
              onPreviousPressed: onPreviousPressed,
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          color: Colors.white,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      centerTitle: true,
      title: new StreamBuilder(
          stream: AudioPlayerProvider.of(context).bufferingValue,
          builder:
              (BuildContext context, AsyncSnapshot<int> bufferingSnapshot) {
            String title = "";
            if (bufferingSnapshot.hasData) {
              title = "Buffering : ${bufferingSnapshot.data.toString()}%";
            }
            return Text(title,style: new TextStyle(fontSize: 14),);
          }),
    );
  }
}
