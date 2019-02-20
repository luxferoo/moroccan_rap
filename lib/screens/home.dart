import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import '../widgets/carousel.dart';
import '../Helpers/admob.dart';
import '../Helpers/string.dart';
import '../models/track.dart';
import '../blocs/artist_provider.dart';
import '../blocs/track_provider.dart';
import '../widgets/artist_card.dart';
import '../Helpers/globals.dart';
import '../widgets/recent_published_track_link.dart';
import '../repositories/artist.dart' as ArtistRepos;
import '../repositories/track.dart' as TrackRepos;
import '../widgets/carousel_item.dart';

class Home extends StatelessWidget {
  final Globals globals = Globals();

  @override
  Widget build(BuildContext context) {
    final ArtistBloc artistBloc = ArtistProvider.of(context);
    final TrackBloc trackBloc = TrackProvider.of(context);

    myBanner
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
      );

    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
          child: CustomScrollView(
            slivers: <Widget>[
              _buildSliverAppBar(trackBloc),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildSectionTitle("Recent tracks"),
                    Container(
                      height: 220,
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
          trackBloc.fetchCarouselPlaylist();
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
                child: RecentPublishedTrackLink(
                  picture: tracks[index].picture,
                  artistName: tracks[index].artistName,
                  name: tracks[index].name,
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed("/player/recent/$index");
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

  Widget _buildSliverAppBar(TrackBloc bloc) {
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: new StreamBuilder(
        stream: bloc.carouselPlaylist,
        builder: (BuildContext context, AsyncSnapshot<List<Track>> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          }
          return Carousel(
            children: snapshot.data.map((track) {
              return new CarouselItem(
                trackId: track.id,
                trackName: cropText(capitalize(track.name), 15),
                artistName: cropText(capitalize(track.artistName), 20),
                picture: globals.serverPath + track.picture,
                onPressed: () => Navigator.of(context).pushNamed(
                    '/player/carousel/${snapshot.data.indexOf(track)}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
