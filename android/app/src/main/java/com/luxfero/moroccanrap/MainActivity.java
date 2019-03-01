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

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
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

        if (!isMyServiceRunning(AudioService.class))
            startService(new Intent(this, AudioService.class));

        methodChannel.setMethodCallHandler(
                (call, result) -> {
                    if (mBound) {
                        switch (call.method) {
                            case "ping":
                                startPlaybackListener();
                                break;
                            case "startAudioService":
                                try {
                                    mService.setDataSource(((Map) call.arguments()).get("track").toString());
                                    startPlaybackListener();
                                    result.success(true);
                                } catch (IOException e) {
                                    e.printStackTrace();
                                }
                                break;
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
                    }
                });
    }

    private void initAudioServiceListener() {
        mService.getMediaPlayer().setOnBufferingUpdateListener((mediaPlayer, percent) -> {
            methodChannel.invokeMethod("onBufferingUpdate", percent);
            if (percent < 100)
                methodChannel.invokeMethod("onStateChanged", "buffering");
            if (percent == 100)
                methodChannel.invokeMethod("onStateChanged", "playing");
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

    private boolean isMyServiceRunning(Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.getName().equals(service.service.getClassName())) {
                return true;
            }
        }
        return false;
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
                        methodChannel.invokeMethod("currentPosition", mService.getCurrentPosition());
                        methodChannel.invokeMethod("duration", mService.getDuration());
                        playbackListenerHandler.postDelayed(this, 500);
                    }
                }
            }, 500);
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        Intent intent = new Intent(this, AudioService.class);
        bindService(intent, connection, Context.BIND_AUTO_CREATE);
    }

    @Override
    protected void onStop() {
        super.onStop();
        unbindService(connection);
        mBound = false;
    }
}
