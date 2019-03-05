package com.luxfero.moroccanrap;

import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.util.Log;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {
    private AudioService mService;
    private Boolean mBound = false;
    private Boolean isPlaybackListener = false;
    private Handler playbackListenerHandler;
    private MethodChannel methodChannel;

    public static final String Broadcast_PLAY_NEW_AUDIO = "com.example.luxfero.mymediaplayer.PlayNewAudio";
    ArrayList<Audio> audioList = new ArrayList<>();


    private static final String CHANNEL = "com.luxfero.moroccanrap/audio_service";
    private ServiceConnection connection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            AudioService.LocalBinder binder = (AudioService.LocalBinder) service;
            mService = binder.getService();
            HandlerThread handlerThread = new HandlerThread("AudioService");
            handlerThread.start();
            playbackListenerHandler = new Handler(handlerThread.getLooper());
            initAudioServiceListener();
            startPlaybackListener();
            mBound = true;
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

        /*if (!isMyServiceRunning(AudioService.class))
            startService(new Intent(this, AudioService.class));*/

        methodChannel.setMethodCallHandler(
                (call, result) -> {
                    switch (call.method) {
                        case "ping":
                            //startPlaybackListener();
                            break;
                        case "setPlaylist":
                            setPlaylist();
                            playAudio(0);
                            startPlaybackListener();
                            methodChannel.invokeMethod("onStateChanged", "playing");
                            break;
                            /*case "startAudioService":
                                try {
                                    SharedPreferences.Editor editor = sharedpreferences.edit();
                                    String trackId = ((Map) call.arguments()).get("id").toString();
                                    String trackUrl = ((Map) call.arguments()).get("track").toString();
                                    if (!sharedpreferences.getString("current_track_id", "").equals(trackId)) {
                                        Log.d("khraaa", sharedpreferences.getString("current_track_id", "") + trackId);
                                        mService.setDataSource(trackUrl);
                                        methodChannel.invokeMethod("onStateChanged", "playing");
                                        editor.putString("current_track_id", trackId);
                                        editor.commit();
                                        //TODO implement callback
                                        startPlaybackListener();
                                    }
                                    result.success(true);
                                } catch (IOException e) {
                                    e.printStackTrace();
                                }
                                break;
                                */
                        case "play":
                            mService.play();
                            methodChannel.invokeMethod("onStateChanged", "playing");
                            startPlaybackListener();
                            result.success(true);
                            break;
                        case "pause":
                            mService.pause();
                            methodChannel.invokeMethod("onStateChanged", "paused");
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
                            methodChannel.invokeMethod("onStateChanged", "stopped");
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

    private void initAudioServiceListener() {
        mService.getMediaPlayer().setOnBufferingUpdateListener((mediaPlayer, percent) -> {
            methodChannel.invokeMethod("onBufferingUpdate", percent);
        });

        mService.getMediaPlayer().setOnCompletionListener(mediaPlayer -> {
            methodChannel.invokeMethod("onCompletion", null);
            stopPlaybackListening();
        });

        mService.getMediaPlayer().setOnSeekCompleteListener(mediaPlayer -> {
            methodChannel.invokeMethod("onSeekComplete", null);
        });

        mService.getMediaPlayer().setOnErrorListener((mediaPlayer, what, extra) -> {
            methodChannel.invokeMethod("onError", what);
            stopPlaybackListening();
            return true;
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
                            methodChannel.invokeMethod("onStateChanged", "playing");
                            playbackListenerHandler.postDelayed(this, 500);
                        } catch (IllegalStateException ignored) {

                        }
                    }
                }
            }, 500);
        }
    }

    private void setPlaylist() {
        audioList.add(new Audio("http://206.189.15.19/stream/1551091658105.mp3", "title1", "album1", "artist1"));
        audioList.add(new Audio("http://206.189.15.19/stream/1550490442581.mp3", "title", "album", "artist"));
    }

    private void playAudio(int audioIndex) {
        //Check is service is active
        if (mService == null) {
            StorageUtil storage = new StorageUtil(getApplicationContext());
            storage.storeAudio(audioList);
            storage.storeAudioIndex(audioIndex);
            Intent playerIntent = new Intent(this, AudioService.class);
            startService(playerIntent);
            bindService(playerIntent, connection, Context.BIND_AUTO_CREATE);
        } else {
            StorageUtil storage = new StorageUtil(getApplicationContext());
            storage.storeAudioIndex(audioIndex);
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
        if (mBound) {
            mBound = false;
            unbindService(connection);
        }
    }
}
