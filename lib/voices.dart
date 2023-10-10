import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:permission_handler/permission_handler.dart';

class RecursoDeVoz {
  late FlutterTts tts;
  late SpeechToText speechToText;
  late bool _speechEnabled;
  late double volume;
  late double speed; //pitch
  late double tom; // rate
  late String resposta;

  RecursoDeVoz() {
    tts = FlutterTts();
    speechToText = SpeechToText();

    speed = 1.0;
    tom = 0.5;
    volume = 0.5;
    resposta = '';

    _speechEnabled = false;
    speechToText.initialize();

    _initTts();
    _listenForPermissions();
  }

  _initTts() {
    tts.setLanguage('pt-br');
    tts.setVolume(volume);
    tts.setSpeechRate(tom);
    tts.setPitch(speed);
  }

  void _listenForPermissions() async {
    final status = await Permission.microphone.status;
    if (status == PermissionStatus.denied) {
      _requestForPermission();
    }
  }

  Future<void> _requestForPermission() async {
    await Permission.microphone.request();
  }

  void initSpeech() async {
    _speechEnabled = await speechToText.initialize();
    print("microfone inicializado");
  }

  void speek(String text) {
    tts.speak(text);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    resposta = "$resposta${result.recognizedWords} ";
    print(resposta);
  }

  void _hear() async {
    resposta = '';
    await speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 5),
      localeId: "pt-br",
      cancelOnError: false,
      partialResults: false,
      listenMode: ListenMode.confirmation,
    );
  }

  String hear() {
    _hear();
    print(resposta);
    return resposta;
  }

  // Future<String> startListening() async {
  //   late String resposta;
  //   final now = DateTime.now();

  //   double time_limit = 10;

  //   print('microfone aberto');

  //   await speechToText.listen(onResult: (SpeechRecognitionResult result) {
  //     if (speechToText.isNotListening ||
  //         DateTime.now().difference(now).inSeconds >= time_limit) {
  //       print("entro");
  //       speechToText.stop();
  //     }
  //     resposta = result.recognizedWords;
  //     print('Resposta:  ${resposta}');
  //   });

  //   print(resposta + 'retornada');
  //   return Future.value(resposta);
  // }

  // Future<String> hear() async {
  //   late String resposta;
  //   print('inicio');
  //   if (speechToText.isNotListening) {
  //     print('oi');
  //     resposta = await startListening();
  //     print(resposta);
  //   } else {
  //     speechToText.stop();
  //     print('microfone fechado');
  //   }

  //   print('fim');

  //   if (speechToText.isListening) {
  //     print(resposta);
  //     return Future.value(resposta);
  //   } else if (_speechEnabled) {
  //     return Future.value('microfone habilitado');
  //   }

  //   return Future.value('serviço de escuta nao disponivel');
  // }

  void setSpeed(double speed) {
    this.speed = speed;
  }

  void setVolume(double volume) {
    this.volume = volume;
  }
}
