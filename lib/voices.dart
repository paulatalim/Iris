import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:permission_handler/permission_handler.dart';

class RecursoDeVoz {
  late FlutterTts _textToSpeech;
  late SpeechToText _speechToText;
  late double _volume;
  late double _speed; //pitch
  late double _tom; // rate
  late String _resposta;

  /// Construtor
  RecursoDeVoz() {
    // Inicializa os objetos
    _textToSpeech = FlutterTts();
    _speechToText = SpeechToText();

    // Inicializa os atributos
    _speed = 0.5;
    _tom = 1.0;
    _volume = 1.0;
    _resposta = '';

    // Configurações dos recursos de vozes
    listenForPermissions();
  }

  /// Inicializa o microfone
  Future<void> initSpeech() async {
    await _speechToText.initialize();
    debugPrint("microfone inicializado");
  }

  /// Requisição da permissao para habilitacao do microfone
  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    if (status == PermissionStatus.denied) {
      _requestForPermission();
    }
  }

  /// Busca as requisições necessarias para habilitar microfone
  Future<void> _requestForPermission() async {
    await Permission.microphone.request();
  }

  /// Tranforma o texto em fala
  ///
  /// Passe um texto [text] por parametro para o aplicativo transformar em voz
  Future<void> speek(String text) async {
    await _textToSpeech.setLanguage('pt-br');
    await _textToSpeech.setVolume(_volume);
    await _textToSpeech.setSpeechRate(_speed);
    await _textToSpeech.setPitch(_tom);

    await _textToSpeech.speak(text);
  }

  Future status () async {
    return Future.value(_textToSpeech.awaitSpeakCompletion(true));
  }

  /// Escuta o que o usuario está falando e tranforma em texto
  ///
  /// O resultado [result] capturado em audio é transformado em texto
  void _onSpeechResult(SpeechRecognitionResult result) {
    _resposta = "$_resposta${result.recognizedWords} ";
    debugPrint(_resposta);
  }

  /// Habilita o microfone e captura a voz
  Future<void> _hear() async {
    _resposta = '';
    
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 5),
      localeId: "pt-br",
      cancelOnError: false,
      partialResults: false,
      listenMode: ListenMode.confirmation,
    );
    
  }

  /// Habilita o microfone, captura o voz e transforma em texto
  ///
  /// Retorna o texto em forma de uma [String]
  Future<String> hear() async {
    print("Antesss uaaaaaaaaaa");

    // Abre o microfone
    await initSpeech();

    print("Antesss");

    // Escuta o usuario
    await _hear();

    print("Depoissssss");

    // Delay de 5 segundos antes do retorno
    await Future.delayed(Duration(seconds: 5));

    print("5");

    // Retorno da _resposta em String
    return Future.value(_resposta);
  }

  /// Velocidade da voz do audio
  ///
  /// Aceita valores entre 0.5 e 2.0
  double get speed => _speed;
  set speed(value) => _speed = value;
  

  /// _Volume da voz do audio
  ///
  /// Aceita valores entre 0.0 e 1.0
  double get volume => _volume;
  set volume(value) => _volume = value;

  String get resposta => _resposta.toLowerCase().trim();
}

RecursoDeVoz voice = RecursoDeVoz();