import 'package:azure_speech_recognition_null_safety/azure_speech_recognition_null_safety.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class Stt {
  late AzureSpeechRecognition _speechAzure;
  late String _subKey;
  late String _region;
  late String _lang;
  final _timeout = "3000";
  bool isRecording = false;
  String resposta = '';

  Stt(String key, String region, String language) {
    _subKey = key;
    _region = region;
    _lang = language;
    _speechAzure = AzureSpeechRecognition();

    _activateSpeechRecognizer();
  }

  Future<void> _permission() async {
    final status = await Permission.microphone.status;

    if (status == PermissionStatus.denied) {
      await Permission.microphone.request();
    }
  }

  void _activateSpeechRecognizer() {
    
    // MANDATORY INITIALIZATION
    AzureSpeechRecognition.initialize(_subKey, _region, lang: _lang, timeout: _timeout);

    resposta = '';
    _speechAzure.setFinalTranscription((text) {
      // do what you want with your final transcription
      resposta = text;
      debugPrint("[MICROFONE] Setting final transcript");
      isRecording = false;
    });

    debugPrint("[MICROFONE] Resposta: $resposta");

    _speechAzure.setRecognitionStartedHandler(() {
      // called at the start of recognition (it could also not be used)
      debugPrint("[MICROFONE] Recognition started");
      isRecording = true;
    });

  }

  void speech() async {
    await _permission();

    try {
      AzureSpeechRecognition.simpleVoiceRecognition();
    } on PlatformException catch (e) {
      debugPrint("[MICROFONE] Failed to get text '${e.message}'.");
    }
  }

  set language(String language) => _lang = language;
}