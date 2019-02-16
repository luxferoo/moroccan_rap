import 'package:flutter/material.dart';
import 'dart:async';

class Carousel extends StatefulWidget {

  final List<Widget> children;

  int get childrenCount => children.length;

  final Curve animationCurve;

  final Duration animationDuration;

  final Duration displayDuration;

  Carousel({
    this.children,
    this.animationCurve = Curves.ease,
    this.animationDuration = const Duration(milliseconds: 250),
    this.displayDuration = const Duration(seconds: 4)
  }) :
        assert(children != null),
        assert(animationCurve != null),
        assert(animationDuration != null),
        assert(displayDuration != null);


  @override
  State createState() => new _CarouselState();

}

class _CarouselState extends State<Carousel> with SingleTickerProviderStateMixin {

  TabController _controller;
  Timer _timer;

  int get nextIndex {
    var nextIndexValue = _controller.index;

    if(nextIndexValue < _controller.length - 1)
      nextIndexValue++;
    else
      nextIndexValue = 0;

    return nextIndexValue;
  }

  @override
  void initState() {
    super.initState();

    _controller = new TabController(length: widget.childrenCount, vsync: this);

    startAnimating();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new TabBarView(
      children: widget.children.map((widget) => new Center(child: widget,)).toList(),
      controller: this._controller,
    );
  }

  void startAnimating() {
    _timer = new Timer.periodic(widget.displayDuration, (_) => this._controller.animateTo(
        this.nextIndex,
        curve: widget.animationCurve,
        duration: widget.animationDuration
    ));
  }

}