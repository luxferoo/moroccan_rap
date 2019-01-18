import 'package:flutter/material.dart';
import '../models/album.dart';
import '../models/artist.dart';
import '../widgets/track_tile.dart';
import '../models/track.dart';
import '../widgets/sliver_app_bar_delegate.dart';

class ArtistDetail extends StatefulWidget {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: _scrollController,
            slivers: _buildSliverContent(),
          ),
          _buildFloatingActionButton()
        ],
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

  Positioned _buildFloatingActionButton() {
    final defaultTopMargin = _expandedHeight - 4.0;
    final startScale = 96.0;
    final endScale = startScale / 2;
    var top = defaultTopMargin;
    var scale = 1.0;

    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - startScale) {
        scale = 1.0;
      } else if (offset < defaultTopMargin - endScale) {
        scale = (defaultTopMargin - endScale - offset) / endScale;
      } else {
        scale = 0.0;
      }
    }

    return Positioned(
      child: Transform.scale(
        scale: scale,
        child: FloatingActionButton(
          heroTag: "1-favorite",
          backgroundColor: Colors.white,
          onPressed: () {},
          child: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
      ),
      right: 16.0,
      top: top,
    );
  }

  Widget _buildFlexibleSpaceBar({@required Artist artist}) {
    return FlexibleSpaceBar(
      background: Hero(
        tag: "${artist.id}-picture",
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment(0.0, 1.2),
              end: Alignment(0.0, -0.5),
              colors: <Color>[Colors.black, Colors.transparent],
            ),
          ),
          child: Image.network(
            "https://cdn.nrjmaroc.com/images/artists/dizzy-dros1513958560.png",
            fit: BoxFit.cover,
            height: 5000,
            width: 5000,
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
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
      actions: <Widget>[IconButton(icon: Icon(Icons.info), onPressed: () {})],
      title: Hero(
        tag: "1-name",
        child: Material(
          color: Colors.transparent,
          child: Text(
            "Dizzy Dros",
            style: TextStyle(color: silverAppBarTextColor, fontSize: 20.0),
          ),
        ),
      ),
      expandedHeight: _expandedHeight,
      pinned: true,
      flexibleSpace: _buildFlexibleSpaceBar(artist: Artist.fromMap({})),
    );
  }

  _buildSliverContent() {
    final sliversContent = <Widget>[
      _buildSliverAppBar(),
    ];

    final Map<String, List<Track>> tracks = {
      "3ali Potter": [
        Track.fromMap({
          "id": 1,
          "trackId": 1,
          "name": "Track name",
          "picture": "picture",
          "trackLink": "link",
          "album": Album.fromMap({"name":"Album name"}),
        })
      ],
    };

    tracks.forEach((String album, List<Track> tracks) {
      sliversContent.add(
        makeHeader('Album : $album , ${tracks.length} tracks'),
      );
      sliversContent.add(
        SliverList(
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
        ),
      );
    });

    return sliversContent;
  }
}

