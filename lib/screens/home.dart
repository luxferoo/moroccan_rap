import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../blocs/artist_provider.dart';
import '../blocs/track_provider.dart';
import '../widgets/artist_card.dart';
import '../widgets/last_published_track_link.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ArtistBloc artistBloc = ArtistProvider.of(context);
    final TrackBloc trackBloc = TrackProvider.of(context);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Moroccan Rap",
          style: TextStyle(
              color: Colors.black, fontFamily: "Rock Salt", fontSize: 15.0),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () {
            return true;
          });
        },
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  height: 100.0,
                  child: _buildLastPublishedTracks(trackBloc),
                ),
              ),
            ),
            _buildArtistList(artistBloc)
          ],
        ),
      ),
    );
  }

  Widget _buildLastPublishedTracks(TrackBloc bloc) {
    return StreamBuilder(
      stream: bloc.lastTracksIds,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return ListView(
            children: <Widget>[],
          );
        }
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            bloc.fetchTrack(snapshot.data[index]);
            return LastPublishedTrackLink(trackId: snapshot.data[index]);
          },
        );
      },
    );
  }

  Widget _buildArtistList(ArtistBloc bloc) {
    return StreamBuilder(
      stream: bloc.artistIds,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return SliverPadding(
            padding: EdgeInsets.all(0.0),
          );
        }
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              bloc.fetchArtist(snapshot.data[index]);
              return ArtistCard(
                artistId: snapshot.data[index],
                onTap: () {
                  Navigator.of(context).pushNamed("/artist_details");
                },
              );
            },
            childCount: snapshot.data.length,
          ),
        );
      },
    );
  }
}
