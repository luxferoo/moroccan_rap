package com.luxfero.moroccanrap;

import android.app.Service;
import android.content.Intent;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Binder;
import android.os.IBinder;

import java.io.IOException;

public class AudioService extends Service {
    private LocalBinder binder = new LocalBinder();
    private MediaPlayer mediaPlayer;
    private Boolean ready = false;

    @Override
    public IBinder onBind(Intent intent) {
        return binder;
    }

    @Override
    public void onCreate() {
        mediaPlayer = new MediaPlayer();
        mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY;
    }

    public void seek(int msec) {
        mediaPlayer.seekTo(msec);
    }


    public void pause() {
        if (mediaPlayer.isPlaying()) {
            mediaPlayer.pause();
        }
    }

    public void play() {
        if (!mediaPlayer.isPlaying() && ready) {
            mediaPlayer.start();
        }
    }

    public void stop() {
        if (mediaPlayer.isPlaying()) {
            mediaPlayer.stop();
        }
    }

    public void setDataSource(String trackUrl) throws IOException {
        mediaPlayer.setOnPreparedListener(mp -> {
            ready = true;
            play();
        });
        mediaPlayer.reset();
        mediaPlayer.setDataSource(trackUrl);
        ready = false;
        mediaPlayer.prepareAsync();
    }


    public int getCurrentPosition() {
        if (ready) {
            return mediaPlayer.getCurrentPosition();
        } else {
            return 0;
        }
    }


    public int getDuration() {
        if (ready) {
            return mediaPlayer.getDuration();
        } else {
            return 0;
        }
    }

    public MediaPlayer getMediaPlayer() {
        return mediaPlayer;
    }

    class LocalBinder extends Binder {
        AudioService getService() {
            return AudioService.this;
        }
    }


    @Override
    public void onDestroy() {
        super.onDestroy();
        mediaPlayer.stop();
        mediaPlayer.release();
    }
}
