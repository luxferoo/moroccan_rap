import 'package:flutter/material.dart';
import '../blocs/artist_provider.dart';
import '../blocs/track_provider.dart';
import '../widgets/artist_card.dart';
import '../widgets/last_published_track_link.dart';
import '../repositories/artist.dart' as ArtistRepos;
import '../repositories/track.dart' as TrackRepos;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ArtistBloc artistBloc = ArtistProvider.of(context);
    final TrackBloc trackBloc = TrackProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Moroccan Rap",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
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
                    height: 220,
                    child: _buildLastPublishedTracks(trackBloc),
                  ),
                  _buildSectionTitle("Artists"),
                ],
              ),
            ),
            _buildArtistList(artistBloc)
          ],
        ),
        onRefresh: () async {
          await ArtistRepos.Artist().clearCache();
          await TrackRepos.Track().clearCache();
          trackBloc.fetchLastTracksIds();
          artistBloc.fetchArtistsIds();
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
            return Container(
                color: Colors.white,
                margin: EdgeInsets.all(2.0),
                child: LastPublishedTrackLink(
                  trackId: snapshot.data[index],
                  onPressed: () {
                    bloc.fetchLastTracks();
                    Navigator.of(context).pushNamed("/player/$index");
                  },
                ),
                width: 170);
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
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 12),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
    );
  }
}
