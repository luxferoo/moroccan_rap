import 'package:flutter/material.dart';

class CarouselItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
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
    );
  }
}