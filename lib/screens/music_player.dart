import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import '../Helpers/admob.dart';
import 'package:flutter/material.dart';
import '../Helpers/string.dart';
import '../models/track.dart';
import '../widgets/audio_radial_seek_bar.dart';
import '../widgets/bottom_controller.dart';
import '../Helpers/globals.dart';
import '../blocs/audio_player_provider.dart';

class MusicPlayer extends StatefulWidget {
  final List<Track> trackList;
  final int startAt;

  MusicPlayer({
    @required this.trackList,
    this.startAt = 0,
  }) : assert(trackList != null);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final Globals globals = Globals();
  int startAt;

  @override
  Widget build(BuildContext context) {
    myInterstitial
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
      );
    startAt = widget.startAt;
    AudioPlayerProvider.of(context)
        .startAudioService(track: widget.trackList[startAt]);
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
                  Text(
                    formatDuration(Duration(seconds: 10)),
                    style: TextStyle(color: Colors.white),
                  ),
                  AudioRadialSeekBar(
                    picture: globals.serverPath +
                        (widget.trackList[startAt].picture ?? ""),
                  ),
                  Text(
                    formatDuration(Duration(seconds: 10)),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            BottomControls(
              songTitle: widget.trackList[startAt].name,
              artistName: widget.trackList[startAt].artistName,
              onNextPressed: () {
                setState(() {
                  if (startAt < widget.trackList.length)
                    ++startAt;
                  else
                    startAt = 0;
                  AudioPlayerProvider.of(context)
                      .startAudioService(track: widget.trackList[startAt]);
                });
              },
              onPreviousPressed: () {
                setState(() {
                  if (startAt != 0) --startAt;
                  AudioPlayerProvider.of(context)
                      .startAudioService(track: widget.trackList[startAt]);
                });
              },
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
    );
  }
}
