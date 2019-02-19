import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacementNamed("/home"),
    );
    return Container(
      color: Colors.black,
      child: Center(
        child: Image.asset("assets/img/splash_image.png"),
      ),
    );
  }
}
