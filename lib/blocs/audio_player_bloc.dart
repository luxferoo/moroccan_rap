import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../models/track.dart';

class AudioPlayerBloc {
  static MethodChannel platform =
      new MethodChannel('com.luxfero.moroccanrap/audio_service');

  VoidCallback onCompletion;

  final BehaviorSubject<String> _stateListener = BehaviorSubject();
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
        onCompletion();
      }

      if (methodName == "duration") {
        _duration.add(arguments);
      }

      if (methodName == "onStateChanged") {
        _stateListener.add(arguments);
      }
    });
  }

  setOnCompletion({VoidCallback cb}) {
    onCompletion = cb;
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

  Future<void> startAudioService({@required Track track}) async {
      try {
        await platform.invokeMethod("startAudioService", track.toMap());
      } on PlatformException catch (e) {}
  }

  play() async {
    try {
      await platform.invokeMethod("play");
    } on PlatformException catch (e) {}
  }

  pause() async {
    try {
      await platform.invokeMethod("pause");
    } on PlatformException catch (e) {}
  }

  stop() async {
    try {
      await platform.invokeMethod("stop");
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
