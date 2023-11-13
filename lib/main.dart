import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'voices.dart';
import 'menu.dart';
 import 'speech.dart';
 import 'speek.dart';


RecursoDeVoz voice = RecursoDeVoz();



void main() {
  // Configuração que permite a utilizacao do app somente com a tela no modo retrato
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  ///Reconhecer a fala
  //voice.onSpeechResult(result as SpeechRecognitionResult);
  voice.speek("coomo posso");

  runApp(MaterialApp(
    title: 'Iris',
    theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFdba0ff),
        )),
    debugShowCheckedModeBanner: false,
    home: const Menubar(),
    // home: SpeechScreen(),
    // home: Speek(),
  ));
}
