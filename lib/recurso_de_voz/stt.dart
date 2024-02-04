// import 'dart:convert';
// import 'dart:typed_data';
import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:azure_speech_recognition_null_safety/azure_speech_recognition_null_safety.dart';

class Stt {
  late AzureSpeechRecognition _speechAzure;
  String subKey = "53cada5a127d4d3c88f518d736af77f2";
  String region = "brazilsouth";
  String lang = "en-US";
  String timeout = "5000";
  bool isRecording = false;
  String resposta = '';

  Stt() {
    _speechAzure = AzureSpeechRecognition();

    activateSpeechRecognizer();
  }

  Future<void> permission() async {
    final status = await Permission.microphone.status;

    if (status == PermissionStatus.denied) {
      await Permission.microphone.request();
    }
  }

  void activateSpeechRecognizer() {
    
    // MANDATORY INITIALIZATION
    AzureSpeechRecognition.initialize(subKey, region, lang: lang, timeout: timeout);

    resposta = '';
    _speechAzure.setFinalTranscription((text) {
      // do what you want with your final transcription
      resposta = text;
      debugPrint("Setting final transcript");
      isRecording = false;
    });

    print(resposta);

    _speechAzure.setRecognitionStartedHandler(() {
      // called at the start of recognition (it could also not be used)
      debugPrint("Recognition started");
      isRecording = true;
    });

  }

  void speech() async {
    await permission();

    try {
      AzureSpeechRecognition.simpleVoiceRecognition();
    } on PlatformException catch (e) {
      print("Failed to get text '${e.message}'.");
    }
  }

//   void speech1() async {
//     await permission();

//     var request = http.MultipartRequest(
//       'POST',
//         Uri.parse(
//             'https://brazilsouth.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US&format=detailed'),
//       );

//       request.headers.addAll({
//         'Ocp-Apim-Subscription-Key': '53cada5a127d4d3c88f518d736af77f2',
//         'Content-Type': 'audio/wav',
//       }
//     );

//     Uint8List audioBytes = getAudioBytes();
//     request = http.MultipartRequest(
//       'POST',
//       Uri.parse(
//           'https://brazilsouth.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US&format=detailed'),
//       );
//       request.files.add(
//         http.MultipartFile.fromBytes('file', audioBytes, filename: 'audio.wav'));

//         request.headers.addAll({
//       'Ocp-Apim-Subscription-Key': '53cada5a127d4d3c88f518d736af77f2',
//       'Content-Type': 'audio/wav',
//     });

//     var response = await request.send();

//     // Lendo a resposta como texto
//     String responseText = await utf8.decode(await response.stream.toBytes());

//     print(responseText);
//   }

//   Uint8List getAudioBytes() {
//   //aqui tem que fazer o audio recebido se transformar em bytes para passar lá em cima
//   throw UnimplementedError();
// }

}