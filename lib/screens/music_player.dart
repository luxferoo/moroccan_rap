import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import '../Helpers/admob.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../Helpers/string.dart';
import '../models/track.dart';
import '../widgets/audio_radial_seek_bar.dart';
import '../widgets/bottom_controller.dart';
import '../Helpers/globals.dart';

class MusicPlayer extends StatefulWidget {
  final int startAt;
  final Observable<List<Track>> playlistStreamSource;

  MusicPlayer({this.startAt = 0, @required this.playlistStreamSource})
      : assert(playlistStreamSource != null);

  @override
  State<StatefulWidget> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final Globals globals = Globals();

  @override
  Widget build(BuildContext context) {
    myInterstitial
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
      );
    return StreamBuilder(
      stream: widget.playlistStreamSource,
      builder: (BuildContext context, AsyncSnapshot<List<Track>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: Colors.black,
            child: AppBar(
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
            ),
          );
        } else {
          return _buildAudioPlaylist(snapshot.data);
        }
      },
    );
  }

  AudioPlaylist _buildAudioPlaylist(List<Track> trackList) {
    AppBar _buildAppBar(AudioPlayer player) {
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            color: Colors.white,
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              player.dispose();
              player.pause();
              Navigator.of(context).pop();
            }),
      );
    }

    _willPop(AudioPlayer player) async {
      player.dispose();
      player.pause();
      return true;
    }

    return AudioPlaylist(
      startPlayingFromIndex: widget.startAt,
      playbackState: PlaybackState.playing,
      playlist: trackList.map((Track track) {
        return globals.trackStreamPath + track.track;
      }).toList(),
      child: AudioComponent(
        updateMe: [
          WatchableAudioProperties.audioPlayerState,
          WatchableAudioProperties.audioBuffering,
          WatchableAudioProperties.audioPlayhead
        ],
        playerBuilder:
            (BuildContext context, AudioPlayer player, Widget child) {
          return WillPopScope(
            onWillPop: () => _willPop(player),
            child: Scaffold(
              backgroundColor: Colors.black,
              body: AudioPlaylistComponent(
                playlistBuilder:
                    (BuildContext context, Playlist playlist, Widget child) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter:
                            ColorFilter.mode(Colors.black45, BlendMode.darken),
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            globals.serverPath +
                                (trackList[playlist.activeIndex]
                                        .artistPicture ??
                                    ""),
                            headers: {"app_key": globals.appKey}),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        _buildAppBar(player),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                formatDuration(player.position),
                                style: TextStyle(color: Colors.white),
                              ),
                              AudioRadialSeekBar(
                                picture: globals.serverPath +
                                    (trackList[playlist.activeIndex].picture ??
                                        ""),
                              ),
                              Text(
                                formatDuration(player.audioLength),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        BottomControls(
                          audioPlayer: player,
                          songTitle: trackList[playlist.activeIndex].name,
                          artistName:
                              trackList[playlist.activeIndex].artistName,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
