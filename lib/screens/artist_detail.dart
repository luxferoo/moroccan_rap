import 'package:flutter/material.dart';
import '../blocs/track_provider.dart';
import '../models/album.dart';
import '../models/artist.dart';
import '../widgets/track_tile.dart';
import '../models/track.dart';
import '../widgets/sliver_app_bar_delegate.dart';
import '../blocs/artist_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../repositories/track.dart' as TrackRepo;

class ArtistDetail extends StatefulWidget {
  final int artistId;

  ArtistDetail({this.artistId});

  @override
  State<StatefulWidget> createState() => _ArtistState();
}

class _ArtistState extends State<ArtistDetail> {
  final double _expandedHeight = 400.0;
  final _scrollController = new ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final artistBloc = ArtistProvider.of(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: TrackRepo.Track().fetchTracksByArtistId(widget.artistId),
          builder: (BuildContext context, AsyncSnapshot<List<Track>> snapshot) {
            if (!snapshot.hasData) {
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _buildSliverAppBar(artistBloc),
                ],
              );
            } else {
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _buildSliverAppBar(artistBloc),
                  _buildTracksList(snapshot.data),
                ],
              );
            }
          },
        ));
  }

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 70.0,
        child: Container(
          color: Colors.white,
          child: Center(
            child: Text(
              headerText,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlexibleSpaceBar(ArtistBloc bloc) {
    return FlexibleSpaceBar(
      background: Hero(
        tag: "${widget.artistId}-picture",
        child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                end: Alignment(1.0, 0.0),
                begin: Alignment(0.0, -2),
                colors: <Color>[Colors.black, Colors.transparent],
              ),
            ),
            child: StreamBuilder(
              stream: bloc.artist,
              builder: (BuildContext context,
                  AsyncSnapshot<Map<int, Future<Artist>>> snapshot) {
                if (!snapshot.hasData) {
                  return Container(color: Colors.black);
                }
                return FutureBuilder(
                  future: snapshot.data[widget.artistId],
                  builder: (BuildContext context,
                      AsyncSnapshot<Artist> artistSnapshot) {
                    if (!artistSnapshot.hasData) {
                      return Container(color: Colors.black);
                    }
                    return CachedNetworkImage(
                      errorWidget: Image(
                        image: AssetImage("assets/img/picture-placeholder.png"),
                      ),
                      imageUrl: artistSnapshot.data.picture,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    );
                  },
                );
              },
            )),
      ),
    );
  }

  Widget _buildSliverAppBar(ArtistBloc artistBloc) {
    Color silverAppBarTextColor = Colors.white;
    final defaultTopMargin = _expandedHeight - 20.0;
    final startScale = 96.0;
    final endScale = startScale / 2;

    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;
      if (offset < defaultTopMargin - endScale) {
        silverAppBarTextColor = Colors.white;
      } else {
        silverAppBarTextColor = Colors.black;
      }
    }
    return SliverAppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: silverAppBarTextColor),
      title: StreamBuilder(
        stream: artistBloc.artist,
        builder: (BuildContext context,
            AsyncSnapshot<Map<int, Future<Artist>>> snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          }
          return FutureBuilder(
            future: snapshot.data[widget.artistId],
            builder:
                (BuildContext context, AsyncSnapshot<Artist> artistSnapshot) {
              if (!artistSnapshot.hasData) {
                return SizedBox();
              }
              return Text(
                artistSnapshot.data.name,
                style: TextStyle(color: silverAppBarTextColor, fontSize: 20.0),
              );
            },
          );
        },
      ),
      expandedHeight: _expandedHeight,
      pinned: true,
      flexibleSpace: _buildFlexibleSpaceBar(artistBloc),
    );
  }

  _buildTracksList(List<Track> tracks) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, index) {
          return Column(
            children: <Widget>[
              TrackTile(track: tracks[index]),
              Divider(
                height: 0.0,
              )
            ],
          );
        },
        childCount: tracks.length,
      ),
    );
  }
}