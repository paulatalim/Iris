import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:permission_handler/permission_handler.dart';

class RecursoDeVoz {
  late FlutterTts tts;
  late SpeechToText speechToText;
  late double volume;
  late double speed; //pitch
  late double tom; // rate
  late String resposta;

  /// Construtor
  RecursoDeVoz() {
    // Inicializa os objetos
    tts = FlutterTts();
    speechToText = SpeechToText();

    // Inicializa os atributos
    speed = 1.0;
    tom = 0.5;
    volume = 0.5;
    resposta = '';

    // Configurações dos recursos de vozes
    _initTts();
    _listenForPermissions();
  }

  /// Configura da voz do app
  _initTts() {
    tts.setLanguage('pt-br');
    tts.setVolume(volume);
    tts.setSpeechRate(tom);
    tts.setPitch(speed);
  }

  /// Inicializa o microfone
  void _initSpeech() async {
    await speechToText.initialize();
    print("microfone inicializado");
  }

  /// Requisição da permissao para habilitacao do microfone
  void _listenForPermissions() async {
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
  void speek(String text) {
    tts.speak(text);
  }

  /// Escuta o que o usuario está falando e tranforma em texto
  ///
  /// O resultado [result] capturado em audio é transformado em texto
  void _onSpeechResult(SpeechRecognitionResult result) {
    resposta = "$resposta${result.recognizedWords} ";
    print(resposta);
  }

  /// Da uma pausa no aplicativo para as funções serem executadas
  ///
  /// Coloque o tempo de pausa em segundos [seconds] para o tempo de pausa
  Future<void> delay(int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
  }

  /// Habilita o microfone e captura a voz
  Future<void> _hear() async {
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

  /// Habilita o microfone, captura o voz e transforma em texto
  ///
  /// Retorna o texto em forma de uma [String]
  Future<String> hear() async {
    // Abre o microfone
    _initSpeech();

    // Escuta o usuario
    await _hear();

    // Delay de 5 segundos antes do retorno
    await delay(5);

    // Retorno da resposta em String
    return Future.value(resposta);
  }

  /// Velocidade da voz do audio
  ///
  /// Aceita valores entre 0.5 e 2.0
  double get speedVoice => speed;
  set speedVoice(double speed) {
    this.speed = speed;
    tts.setPitch(speed);
  }

  /// Volume da voz do audio
  ///
  /// Aceita valores entre 0.0 e 1.0
  double get volumeVoice => volume;
  set volumeVoice(double volume) {
    this.volume = volume;
    tts.setVolume(volume);
  }
}
