import 'dart:math';
import 'package:flutter/material.dart';

class CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: min(size.width, size.height) / 2);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}
