import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../models/track.dart';

class AudioPlayerBloc {
  static MethodChannel platform =
      new MethodChannel('com.luxfero.moroccanrap/audio_service');

  VoidCallback _onCompletion;
  VoidCallback _onNext;
  VoidCallback _onPrevious;
  VoidCallback _onPause;
  VoidCallback _onPlay;

  final PublishSubject<String> _stateListener = PublishSubject();
  final PublishSubject<int> _currentPositionListener = PublishSubject();
  final PublishSubject<int> _bufferingListener = PublishSubject();
  final PublishSubject<int> _onSeekListener = PublishSubject();
  final PublishSubject<int> _duration = PublishSubject();

  AudioPlayerBloc() {
    platform.setMethodCallHandler((MethodCall method) {
      String methodName = method.method;
      dynamic arguments = method.arguments;
      if (methodName == "onCurrentPositionChanged") {
        _currentPositionListener.add(arguments);
      }

      if (methodName == "onBufferingUpdate") {
        _bufferingListener.add(arguments);
      }

      if (methodName == "onSeekComplete") {
        _onSeekListener.add(arguments);
      }

      if (methodName == "onCompletion") {
        _onCompletion();
      }

      if (methodName == "duration") {
        _duration.add(arguments);
      }

      if (methodName == "onStateChanged") {
        _stateListener.add(arguments);
      }

      if (methodName == "onNext") {
        _onNext();
      }

      if (methodName == "onPrevious") {
        _onPrevious();
      }

      if (methodName == "onPause") {
        _onPause();
        _stateListener.add("paused");
      }

      if (methodName == "onPlay") {
        _onPlay();
        _stateListener.add("playing");
      }

      if (methodName == "onStop") {
        _onPause();
        _stateListener.add("stoped");
      }

    });
  }

  setOnCompletion({VoidCallback cb}) {
    _onCompletion = cb;
  }

  setOnNext({VoidCallback cb}) {
    _onNext = cb;
  }

  setOnPrevious({VoidCallback cb}) {
    _onPrevious = cb;
  }

  setOnPause({VoidCallback cb}) {
    _onPause = cb;
  }

  setOnPlay({VoidCallback cb}) {
    _onPlay = cb;
  }

  Observable<String> get playerState => _stateListener.stream;

  Observable<int> get currentPosition => _currentPositionListener.stream;

  Observable<int> get bufferingValue => _bufferingListener.stream;

  Observable<int> get duration => _duration.stream;

  Observable<int> get seekValue => _onSeekListener.stream;

  Future<void> ping() async {
    try {
      await platform.invokeMethod("ping");
    } on PlatformException catch (e) {}
  }

  Future<void> setPlaylist(
      {@required List<Map> tracks, int startAt = 0}) async {
    try {
      await platform.invokeMethod("setStartAt", startAt);
      await platform.invokeMethod("setPlaylist", tracks);
      _stateListener.add("playing");
    } on PlatformException catch (e) {}
  }

  play() async {
    try {
      await platform.invokeMethod("play");
      _stateListener.add("playing");
    } on PlatformException catch (e) {}
  }

  pause() async {
    try {
      await platform.invokeMethod("pause");
      _stateListener.add("paused");
    } on PlatformException catch (e) {}
  }

  next() async {
    try {
      await platform.invokeMethod("next");
    } on PlatformException catch (e) {}
  }

  previous() async {
    try {
      await platform.invokeMethod("previous");
    } on PlatformException catch (e) {}
  }

  stop() async {
    try {
      await platform.invokeMethod("stop");
      _stateListener.add("stoped");
    } on PlatformException catch (e) {}
  }

  seek(int ms) async {
    try {
      await platform.invokeMethod("seek", ms);
    } on PlatformException catch (e) {}
  }

  dispose() {
    _stateListener.close();
    _currentPositionListener.close();
    _bufferingListener.close();
    _onSeekListener.close();
    _duration.close();
  }
}
