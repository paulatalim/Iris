import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'menu.dart';

void main() {
  // Configuração que permite a utilizacao do app somente com a tela no modo retrato
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MaterialApp(
    title: 'Iris',
    theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFdba0ff),
        )),
    debugShowCheckedModeBanner: false,
    home: Menubar(index: 0),
  ));
}
