import 'package:flutter/material.dart';
import 'package:moroccan_rap/Helpers/string.dart';
import '../widgets/carousel.dart';
import '../models/track.dart';
import '../blocs/artist_provider.dart';
import '../blocs/track_provider.dart';
import '../widgets/artist_card.dart';
import '../widgets/last_published_track_link.dart';
import '../repositories/artist.dart' as ArtistRepos;
import '../repositories/track.dart' as TrackRepos;
import '../widgets/carousel_item.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ArtistBloc artistBloc = ArtistProvider.of(context);
    final TrackBloc trackBloc = TrackProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        leading: Padding(
            padding: EdgeInsets.all(10.0),
            child: Image.asset(
              "assets/img/ic_launcher-hdpi.png",
            )),
        centerTitle: true,
        title: Text(
          "Moroccan Rap",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
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
                      child: _buildRecentTracks(trackBloc),
                    ),
                    _buildSectionTitle("Artists"),
                  ],
                ),
              ),
              _buildArtistList(artistBloc)
            ],
          ),
        ),
        onRefresh: () async {
          await ArtistRepos.Artist().clearCache();
          await TrackRepos.Track().clearCache();
          trackBloc.fetchRecentTracks();
          artistBloc.fetchArtistsIds();
        },
      ),
    );
  }

  Widget _buildRecentTracks(TrackBloc bloc) {
    return StreamBuilder(
      stream: bloc.recentTracksPlaylist,
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
                    Navigator.of(context)
                        .pushNamed("/recent-tracks-player/$index");
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
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildCarousel() {
    return Container(
      height: 280,
      child: Carousel(
        children: [
          new CarouselItem(
              trackId: 1,
              trackName: cropText(capitalize("Track Name 1"),15),
              artistName: cropText(capitalize("Artist Name 1"),20),
              picture:
                  "http://206.189.15.19/uploads/track/picture/1550077916387.jpeg"),
          new CarouselItem(
              trackId: 2,
              trackName: cropText(capitalize("Track Name 2"),15),
              artistName: cropText(capitalize("Artist Name 2"),20),
              picture:
                  "http://206.189.15.19/uploads/track/picture/1550077916387.jpeg"),
          new CarouselItem(
              trackId: 3,
              trackName: cropText(capitalize("Track Name 3"),15),
              artistName: cropText(capitalize("Artist Name 3"),20),
              picture:
                  "http://206.189.15.19/uploads/track/picture/1550077916387.jpeg"),
        ],
      ),
    );
  }
}
