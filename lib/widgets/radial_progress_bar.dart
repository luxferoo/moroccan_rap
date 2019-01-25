import 'dart:math';
import 'package:flutter/material.dart';

class RadialProgressBar extends StatefulWidget {
  final double trackWidth;
  final double progressWith;
  final double thumbSize;
  final double progressPercent;
  final double thumbPosition;
  final Color trackColor;
  final Color progressColor;
  final Color thumbColor;
  final Widget child;

  RadialProgressBar({
    Key key,
    this.trackWidth = 1.0,
    this.progressWith = 3.0,
    this.thumbSize = 8.0,
    this.trackColor = Colors.grey,
    this.progressColor = Colors.black,
    this.thumbColor = Colors.black,
    this.progressPercent = 0.0,
    this.thumbPosition = 0.0,
    this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RadialProgressBarState();
}

class _RadialProgressBarState extends State<RadialProgressBar> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _RadialProgressBarPainter(
        trackWidth: widget.trackWidth,
        progressWith: widget.progressWith,
        thumbSize: widget.thumbSize,
        trackColor: widget.trackColor,
        progressColor: widget.progressColor,
        thumbColor: widget.thumbColor,
        progressPercent: widget.progressPercent,
        thumbPosition: widget.thumbPosition,
      ),
      child: Padding(
        child: widget.child,
        padding: EdgeInsets.all(10.0),
      ),
    );
  }
}

class _RadialProgressBarPainter extends CustomPainter {
  final double trackWidth;
  final double progressWith;
  final double thumbSize;
  final double progressPercent;
  final double thumbPosition;
  final Color trackColor;
  final Color progressColor;
  final Color thumbColor;
  final Paint trackPaint;
  final Paint thumbPaint;
  final Paint progressPaint;

  _RadialProgressBarPainter({
    @required this.trackWidth,
    @required this.progressWith,
    @required this.thumbSize,
    @required this.progressPercent,
    @required this.thumbPosition,
    @required this.trackColor,
    @required this.progressColor,
    @required this.thumbColor,
  })  : trackPaint = Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = trackWidth,
        progressPaint = Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = progressWith
          ..strokeCap = StrokeCap.round,
        thumbPaint = Paint()
          ..color = thumbColor
          ..style = PaintingStyle.fill
          ..strokeWidth = trackWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    canvas.drawCircle(center, radius, trackPaint);

    final progressAngle = 2 * pi * progressPercent;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        progressAngle, false, progressPaint);

    //TODO learn about cos/sin...
    final thumbAngle = 2 * pi * thumbPosition - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbRadius = thumbSize / 2;
    final thumbCenter = Offset(thumbX, thumbY) + center;

    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
