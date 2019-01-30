import 'dart:math';

import 'package:flutter/material.dart';
import 'circle_clipper.dart';
import 'radial_progress_bar.dart';
import 'radial_drag_gesture_detector.dart';

class RadialSeekBar extends StatefulWidget {
  final double seekPercent;
  final double progress;
  final Function(double) onSeekRequested;

  final String picture;

  const RadialSeekBar(
      {Key key,
      @required this.picture,
      this.seekPercent = 0.0,
      this.progress = 0.0,
      this.onSeekRequested})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {
  double _currentDragPercent;
  double _progress = 0.0;
  PolarCoord _startDragCoord;
  double _startDragPercent;

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  @override
  void didUpdateWidget(RadialSeekBar old) {
    super.didUpdateWidget(old);
    _progress = widget.progress;
  }

  _onDragStart(PolarCoord coord) {
    _startDragCoord = coord;
    _startDragPercent = _progress;
  }

  _onDragUpdate(PolarCoord coord) {
    final dragAngle = coord.angle - _startDragCoord.angle;
    final dragPercent = dragAngle / (2 * pi);
    setState(
        () => _currentDragPercent = (_startDragPercent + dragPercent) % 1.0);
  }

  _onDragEnd() {
    if (widget.onSeekRequested != null) {
      widget.onSeekRequested(_currentDragPercent);
    }
    setState(() {
      _startDragCoord = null;
      _currentDragPercent = null;
      _startDragPercent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double thumbPosition = _progress;
    if (_currentDragPercent != null) {
      thumbPosition = _currentDragPercent;
    } else if (widget.seekPercent != null) {
      thumbPosition = widget.seekPercent;
    }

    return RadialDragGestureDetector(
      onRadialDragStart: _onDragStart,
      onRadialDragUpdate: _onDragUpdate,
      onRadialDragEnd: _onDragEnd,
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 200.0,
            height: 200.0,
            child: RadialProgressBar(
              progressPercent: _progress,
              thumbPosition: thumbPosition,
              thumbColor: Theme.of(context).accentColor,
              progressColor: Theme.of(context).accentColor,
              trackColor: Colors.grey[300],
              child: ClipOval(
                child: Image.network(
                  widget.picture,
                  fit: BoxFit.cover,
                ),
                clipper: CircleClipper(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
