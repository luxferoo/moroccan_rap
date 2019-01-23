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
            color: Colors.black,
            fontFamily: "Rock Salt",
            fontSize: 15.0,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildSectionTitle("Recent tracks"),
                  Container(
                    height: 270,
                    child: _buildLastPublishedTracks(trackBloc),
                  ),
                  _buildSectionTitle("Artists"),
                ],
              ),
            ),
            _buildArtistList(artistBloc)
          ],
        ),
        onRefresh: () {
          return Future.delayed(Duration(seconds: 0), () {
            artistBloc.fetchArtistsIds();
          });
        },
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
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            bloc.fetchTrack(snapshot.data[index]);
            return Card(
                child: Container(
                    child:
                        LastPublishedTrackLink(trackId: snapshot.data[index]),
                    width: 200));
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
            maxCrossAxisExtent: 200.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              bloc.fetchArtist(snapshot.data[index]);
              return ArtistCard(
                artistId: snapshot.data[index],
                onTap: () {
                  Navigator.of(context)
                      .pushNamed("/artist_details/${snapshot.data[index]}");
                },
              );
            },
            childCount: snapshot.data.length,
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 2),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
    );
  }
}
