
import 'package:flutter/material.dart';
import '../widgets/circle_clipper.dart';
import '../widgets/bottom_controller.dart';
import '../widgets/radial_seek_bar.dart';

class MusicPlayer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.grey[300],
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.menu),
            color: Colors.grey[300],
            onPressed: () {},
          ),
        ],
        title: Text(""),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Container(
                width: 125.0,
                height: 125.0,
                child: RadialSeekBar(
                  progressPercent: 0.5,
                  thumbPosition: 0.5,
                  thumbColor: Theme.of(context).primaryColor,
                  progressColor: Theme.of(context).accentColor,
                  trackColor: Colors.grey[300],
                  child: ClipOval(
                    child: Image.network(
                      "https://i.ytimg.com/vi/odpypeUvxHw/hqdefault.jpg",
                      fit: BoxFit.cover,
                    ),
                    clipper: CircleClipper(),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 125.0,
          ),
          BottomControls()
        ],
      ),
    );
  }
}

