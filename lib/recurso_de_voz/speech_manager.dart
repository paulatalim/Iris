import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'stt.dart';
import 'tts.dart';

class Speech {
  final _key = "53cada5a127d4d3c88f518d736af77f2";
  String _language = "en-US";
  final _region = "brazilsouth";

  late Tts _textToSpeech;
  late Stt _speechToText;

  bool? _microphoneOn;
  bool? _controleVozAtivado;
  bool _isTalking = false;
  double _volume = 100;
  double _speed = 1;
  
  Speech() {
    _textToSpeech = Tts(_key, _language);
    _speechToText = Stt(_key, _region, _language);
    _microphoneOn = _speechToText.isRecording;

    _recuperarConfig();
  }

  void _salvarConfig() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("controleVoz", _controleVozAtivado ?? true);
    prefs.setDouble("volume", _volume);
    prefs.setDouble("speed", _speed);
  }

  void _recuperarConfig() async {
    final prefs = await SharedPreferences.getInstance();
    _controleVozAtivado = prefs.getBool("controleVoz") ?? true;
    _volume = prefs.getDouble("volume") ?? 100;
    _speed = prefs.getDouble("speed") ?? 1;

    _textToSpeech.volume = 100 - _volume;
    _setSpeed();
  }

  void _setSpeed() {
    double aux1 = _speed * 100;
    int aux2 = aux1.toInt();
    int aux3;

    if (aux2 - 100 < 0) {
      aux3 = aux2;
    } else {
      aux3 = aux2 - 100;
    }

    _textToSpeech.speed = aux3;
  }

  void setLanguage(String languageCode) {
    switch (languageCode) {
      case 'pt':
        _language = "pt-br";
      case 'en':
      default:
        _language = "en-US";
    }

    // Atualiza idioma
    _speechToText.language = _language;
    _textToSpeech.language = _language;
  }

  Future<void> _songMicrophne() async {
    final AudioPlayer audioPlayer = AudioPlayer();

    final player = AudioCache(prefix: 'assets/audio/');
    final url = await player.load(_microphoneOn! ? 'som_ligado.mp3' : 'som_desligado.mp3');

    await audioPlayer.play(UrlSource(url.path));

    // Espera o sudio termina
    while (audioPlayer.state.toString().compareTo("PlayerState.completed") != 0) {
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> speak(String text) async {
    _isTalking = true;
    _textToSpeech.speak(text);

    // Espera terminar a fala
    do {
      await Future.delayed(const Duration(seconds: 1));
    } while(_textToSpeech.isTalking);

    _isTalking = false;
  }

  /// Ativa o microfone e transforma em texto o som falaso pelo usuario
  Future<String> listen() async {
    // Chamada da API para a traducao de fala em texto
    _speechToText.speech();

    // Caso o microfone nao esteja ativado
    while (!_speechToText.isRecording) {
      await Future.delayed(const Duration(seconds: 1));
    }

    _microphoneOn = true;
    await _songMicrophne();

    // Espera o microfone ser desativado
    do {
      await Future.delayed(const Duration(seconds: 2));
    } while (_speechToText.isRecording);

    _microphoneOn = false;
    await _songMicrophne();

    // Informa a resposta recebida
    debugPrint("[MICROFONE] Resposta: ${_speechToText.resposta}");

    // Formaa a resposta recebida e a retorna
    return Future.value(_speechToText.resposta.toLowerCase().replaceAll(".", '').trim());
  }

  /// Verifica se o microfone stá ligado ou nao
  get microphoneOn => _microphoneOn ?? false;

  get isTalking => _isTalking;

  get controlarPorVoz => _controleVozAtivado;
  set controlarPorVoz (value) {
    _controleVozAtivado = value;
    if(!value) {
      _textToSpeech.stopPlayer();
    }
    _salvarConfig();
  }

  get volume => _volume;
  set volume(value) {
    _volume = value;
    _textToSpeech.volume = 100 - _volume;
    _salvarConfig();
  }

  get speed => _speed;
  set speed(value) {
    _speed = value;
    _setSpeed();
    _salvarConfig();
  }
}

Speech speech = Speech();