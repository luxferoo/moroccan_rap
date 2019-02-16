import 'package:flutter/material.dart';
import '../widgets/caroussel.dart';
import '../models/track.dart';
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
      backgroundColor: Colors.white,
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
                  _buildCarousel(),
                  _buildSectionTitle("Recent tracks"),
                  Container(
                    height: 230,
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
          trackBloc.fetchLastTracks();
          artistBloc.fetchArtistsIds();
        },
      ),
    );
  }

  Widget _buildLastPublishedTracks(TrackBloc bloc) {
    return StreamBuilder(
      stream: bloc.playlist,
      builder: (BuildContext context, AsyncSnapshot<List<Track>> snapshot) {
        if (!snapshot.hasData || snapshot.data.length == 0) {
          return Center(
            child: Text("Could not fetch data."),
          );
        }
        List<Track> tracks = snapshot.data;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return Container(
                color: Colors.white,
                margin: EdgeInsets.all(2.0),
                child: LastPublishedTrackLink(
                  picture: tracks[index].picture,
                  artistName: tracks[index].artistName,
                  name: tracks[index].name,
                  onPressed: () {
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
        if (!snapshot.hasData || snapshot.data.length == 0) {
          return SliverToBoxAdapter(
            child: Center(
              heightFactor: 18,
              child: Text("Could not fetch data."),
            ),
          );
        }

        return SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150.0,
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

  Widget _buildCarousel() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(10.0),
      child: Carousel(
        children: [
          Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(10),
            alignment: Alignment.bottomLeft,
            width: double.infinity,
            height: double.infinity,
            child: Text(
              "Track Name",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.2)),
              image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                fit: BoxFit.cover,
                image: NetworkImage(
                  'http://206.189.15.19/uploads/track/picture/1550077916387.jpeg',
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(10),
            alignment: Alignment.bottomLeft,
            width: double.infinity,
            height: double.infinity,
            child: Text(
              "Track Name",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.2)),
              image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                fit: BoxFit.cover,
                image: NetworkImage(
                  'http://206.189.15.19/uploads/track/picture/1550072992445.jpg',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
