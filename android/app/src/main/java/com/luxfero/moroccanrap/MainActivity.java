package com.luxfero.moroccanrap;

import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.util.Log;

import java.io.IOException;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {
    private AudioService mService;
    private Boolean mBound = false;
    private Intent playerIntent;
    private Boolean isPlaybackListener = false;
    private Handler playbackListenerHandler;
    private MethodChannel methodChannel;
    private int startAt = 0;
    public static final String Broadcast_PLAY_NEW_AUDIO = "com.example.luxfero.mymediaplayer.PlayNewAudio";
    ArrayList<Audio> audioList = new ArrayList<>();


    private static final String CHANNEL = "com.luxfero.moroccanrap/audio_service";
    private ServiceConnection connection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            AudioService.LocalBinder binder = (AudioService.LocalBinder) service;
            mService = binder.getService();
            mBound = true;
            HandlerThread handlerThread = new HandlerThread("AudioService");
            handlerThread.start();
            playbackListenerHandler = new Handler(handlerThread.getLooper());
            mService.setOnBufferingUpdate((mp, percent) -> methodChannel.invokeMethod("onBufferingUpdate", percent));
            mService.setOnCompletionListener(() -> methodChannel.invokeMethod("onNext", null));
            mService.setOnTransportControlsClicked(new AudioService.OnTransportControlsClicked() {
                @Override
                public void next() {
                    methodChannel.invokeMethod("onNext", null);
                }

                @Override
                public void previous() {
                    methodChannel.invokeMethod("onPrevious", null);
                }

                @Override
                public void play() {
                    methodChannel.invokeMethod("onPlay", null);
                }

                @Override
                public void pause() {
                    methodChannel.invokeMethod("onPause", null);
                }

                @Override
                public void stop() {
                    methodChannel.invokeMethod("onStop", null);

                }
            });
            startPlaybackListener();
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            mBound = false;
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        methodChannel = new MethodChannel(getFlutterView(), CHANNEL);


        methodChannel.setMethodCallHandler(
                (call, result) -> {
                    switch (call.method) {
                        case "ping":
                            //startPlaybackListener();
                            result.success(true);
                            break;
                        case "setStartAt":
                            startAt = (int) call.arguments;
                            result.success(true);
                            break;
                        case "setPlaylist":
                            setPlaylist((List<Map>) call.arguments);
                            playAudio(startAt);
                            startPlaybackListener();
                            result.success(true);
                            break;
                        case "play":
                            mService.play();
                            startPlaybackListener();
                            result.success(true);
                            break;
                        case "pause":
                            mService.pause();
                            stopPlaybackListening();
                            result.success(true);
                            break;
                        case "next":
                            mService.next();
                            result.success(true);
                            break;
                        case "previous":
                            mService.previous();
                            result.success(true);
                            break;
                        case "stop":
                            mService.stop();
                            stopPlaybackListening();
                            result.success(true);
                            break;
                        case "seek":
                            mService.seek(call.arguments());
                            result.success(true);
                            break;
                        default:
                            result.notImplemented();
                    }
                });
    }

    private void stopPlaybackListening() {
        isPlaybackListener = false;
        playbackListenerHandler.removeCallbacks(null);
    }

    private void startPlaybackListener() {
        if (!isPlaybackListener && mBound) {
            isPlaybackListener = true;
            playbackListenerHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    if (isPlaybackListener) {
                        try {
                            methodChannel.invokeMethod("onCurrentPositionChanged", mService.getCurrentPosition());
                            methodChannel.invokeMethod("duration", mService.getDuration());
                            //methodChannel.invokeMethod("onStateChanged", "playing");
                            playbackListenerHandler.postDelayed(this, 500);
                        } catch (IllegalStateException ignored) {
                        }
                    }
                }
            }, 500);
        }
    }

    private void setPlaylist(List<Map> list) {
        audioList.clear();
        for (Map audio : list) {
            audioList.add(new Audio((String) audio.get("track"), (String) audio.get("name"), (String) audio.get("name"), (String) audio.get("artistName")));
        }
    }

    private void playAudio(int audioIndex) {
        StorageUtil storage = new StorageUtil(getApplicationContext());
        ArrayList<Audio> currentPlayList = storage.loadAudio();
        if (currentPlayList != null && currentPlayList.size() > audioIndex) {
            if (audioList.get(audioIndex).getData().equals(currentPlayList.get(audioIndex).getData()) && storage.loadAudioIndex() == audioIndex) {
                Log.e(audioList.get(audioIndex).getData(), currentPlayList.get(audioIndex).getData());
                return;
            }
        }
        storage.storeAudioIndex(audioIndex);
        storage.storeAudio(audioList);
        if (mService == null) {
            playerIntent = new Intent(this, AudioService.class);
            startService(playerIntent);
            bindService(playerIntent, connection, Context.BIND_AUTO_CREATE);
        } else {
            mService.updatePlaylist();
            Intent broadcastIntent = new Intent(Broadcast_PLAY_NEW_AUDIO);
            sendBroadcast(broadcastIntent);
        }
    }

    @Override
    public void onSaveInstanceState(Bundle savedInstanceState) {
        savedInstanceState.putBoolean("ServiceState", mBound);
        super.onSaveInstanceState(savedInstanceState);
    }

    @Override
    public void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
        mBound = savedInstanceState.getBoolean("ServiceState");
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if(mBound) {
            mBound = false;
            stopService(playerIntent);
        }
    }
}
