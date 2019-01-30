import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import '../models/track.dart';
import '../blocs/track_provider.dart';
import '../widgets/audio_radial_seek_bar.dart';
import '../widgets/bottom_controller.dart';

class MusicPlayer extends StatefulWidget {
  final int startAt;

  MusicPlayer({this.startAt});

  @override
  State<StatefulWidget> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  int startAt = 0;

  @override
  Widget build(BuildContext context) {
    startAt = widget.startAt ?? 0;
    final trackBloc = TrackProvider.of(context);
    return StreamBuilder(
      stream: trackBloc.playlist,
      builder: (BuildContext context, AsyncSnapshot<List<Track>> snapshot) {
        if (!snapshot.hasData) {
          return Container(color: Colors.black);
        } else {
          return _buildAudioPlaylist(snapshot.data);
        }
      },
    );
  }

  AudioPlaylist _buildAudioPlaylist(List<Track> trackList) {
    AppBar _buildAppBar(AudioPlayer player){
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
      startPlayingFromIndex: startAt,
      playlist: trackList.map((Track track) {
        return track.link;
      }).toList(),
      child: AudioComponent(
        playerBuilder:
            (BuildContext context, AudioPlayer player, Widget child) {
          return WillPopScope(
            onWillPop: ()=>_willPop(player),
            child: Scaffold(
              backgroundColor: Colors.black,
              body: AudioPlaylistComponent(
                playlistBuilder:
                    (BuildContext context, Playlist playlist, Widget child) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Colors.black87, BlendMode.darken),
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              trackList[playlist.activeIndex].artistPicture)),
                    ),
                    child: Column(
                      children: <Widget>[
                        _buildAppBar(player),
                        Expanded(
                          child: AudioRadialSeekBar(
                            picture: trackList[playlist.activeIndex].picture,
                          ),
                        ),
                        BottomControls(
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
