import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'voices.dart';

class AudioPlayerManager {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static void playAudio(bool estado_mic)  {
    String audioPath = estado_mic ? 'som ligado.mp3' : 'som desligado.mp3';

     //_audioPlayer.play(audioPath, isLocal: true);
  }

  static void stopAudio() {
    _audioPlayer.stop();
  }
}

