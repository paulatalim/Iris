import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class RecursoDeVoz {
  late FlutterTts tts;
  late SpeechToText speechToText;
  late bool _speechEnabled;
  late double volume;
  late double speed; //pitch
  late double tom; // rate

  RecursoDeVoz() {
    tts = FlutterTts();
    speechToText = SpeechToText();

    speed = 1.0;
    tom = 0.5;
    volume = 0.5;

    _speechEnabled = false;
    speechToText.initialize();

    initTts();
    initSpeech();
  }

  initTts() {
    tts.setLanguage('pt-br');
    tts.setVolume(volume);
    tts.setSpeechRate(tom);
    tts.setPitch(speed);
  }

  void initSpeech() async {
    _speechEnabled = await speechToText.initialize();
    print("inicializado");
  }

  void speek(String text) {
    tts.speak(text);
  }

  Future<String> startListening() async {
    String resposta = '';

    speechToText.initialize();
    print('microfone aberto');

    await speechToText.listen(onResult: (SpeechRecognitionResult result) {
      resposta = result.recognizedWords;
      print('Resposta:  ${result.recognizedWords}');
    });

    print('final');
    return resposta;
  }

  String hear() {
    String resposta = '';
    if (speechToText.isNotListening) {
      resposta = startListening().toString();
    } else {
      speechToText.stop();
      print('microfone fechado');
    }

    if (speechToText.isListening) {
      print(resposta);
      return resposta;
    } else if (_speechEnabled) {
      return 'microfone habilitado';
    }

    return 'serviço de escuta nao disponivel';
  }

  void setSpeed(double speed) {
    this.speed = speed;
  }

  void setVolume(double volume) {
    this.volume = volume;
  }
}
