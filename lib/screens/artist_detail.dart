import 'package:flutter/material.dart';
import '../blocs/track_provider.dart';
import '../models/artist.dart';
import '../widgets/track_tile.dart';
import '../models/track.dart';
import '../widgets/sliver_app_bar_delegate.dart';
import '../blocs/artist_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../repositories/track.dart' as TrackRepo;
import '../Helpers/globals.dart';

class ArtistDetail extends StatelessWidget {
  final Globals globals = Globals();
  final int artistId;

  ArtistDetail({this.artistId});

  @override
  Widget build(BuildContext context) {
    final artistBloc = ArtistProvider.of(context);
    final trackBloc = TrackProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: TrackRepo.Track().fetchTracksByArtistId(artistId),
        builder: (BuildContext context, AsyncSnapshot<List<Track>> snapshot) {
          List<Widget> slivers = [
            _buildSliverAppBar(context, artistBloc),
            new SliverToBoxAdapter(
              child: new Center(
                heightFactor: 6.5,
                child: new CircularProgressIndicator(),
              ),
            )
          ];

          if (snapshot.hasData) {
            slivers[1] = _buildTracksList(snapshot.data, trackBloc);
          }
          return CustomScrollView(
            slivers: slivers,
          );
        },
      ),
    );
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

  Widget _buildFlexibleSpaceBar(BuildContext context, ArtistBloc bloc) {
    return FlexibleSpaceBar(
      background: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            end: Alignment(1.0, 0.0),
            begin: Alignment(0.0, -2),
            colors: <Color>[
              Theme.of(context).primaryColor,
              Colors.transparent
            ],
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
              future: snapshot.data[artistId],
              builder: (BuildContext context,
                  AsyncSnapshot<Artist> artistSnapshot) {
                if (!artistSnapshot.hasData) {
                  return Container(color: Colors.black);
                }
                return CachedNetworkImage(
                  httpHeaders: {"app_key": globals.appKey},
                  errorWidget: Image(
                    image: AssetImage("assets/img/picture-placeholder.png"),
                  ),
                  imageUrl: globals.serverPath +
                      (artistSnapshot.data.picture ?? ""),
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ArtistBloc artistBloc) {
    return new SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: StreamBuilder(
        stream: artistBloc.artist,
        builder: (BuildContext context,
            AsyncSnapshot<Map<int, Future<Artist>>> snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          }
          return FutureBuilder(
            future: snapshot.data[artistId],
            builder:
                (BuildContext context, AsyncSnapshot<Artist> artistSnapshot) {
              if (!artistSnapshot.hasData) {
                return SizedBox();
              }
              return new Text(
                artistSnapshot.data.name ?? "",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              );
            },
          );
        },
      ),
      expandedHeight: 400.0,
      pinned: true,
      flexibleSpace: _buildFlexibleSpaceBar(context, artistBloc),
    );
  }

  _buildTracksList(List<Track> tracks, TrackBloc bloc) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, index) {
          return Column(
            children: <Widget>[
              TrackTile(
                track: tracks[index],
                onTap: () {
                  bloc.fetchArtistPlaylist(artistId);
                  Navigator.of(context).pushNamed('/player/artist/$index');
                },
              ),
              Divider(
                color: Colors.white,
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
