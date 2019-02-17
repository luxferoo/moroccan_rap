import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacementNamed("/home"),
    );
    return Hero(
      tag: "splash_icon",
      child: Container(
        color: Colors.black,
        child: Center(
          child: Image.asset("assets/img/ic_launcher-xxxhdpi.png"),
        ),
      ),
    );
  }
}
