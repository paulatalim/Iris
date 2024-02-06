import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import '../recurso_de_voz/speech_manager.dart';
import 'configuracao.dart';
import 'loading.dart';
import 'devices.dart';
import 'sobre.dart';
import 'dados.dart';
import 'perfil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool dialogoNaoInicializado = true;
  bool trocarUI = false;
  int index = 0;

  void dialogo() async {
    String resposta = "";
    bool respostaInvalida = true;

    await Future.delayed(const Duration(seconds: 5));
    await speech.speak("Which section of the app would you like to go to? Settings? About us? Devices? Informations? Or Profile?");
    
    while (respostaInvalida) {
      resposta = await speech.listen();
      
      switch (resposta) {
        case "i want to go to settings": 
          _irUIConfiguracao();
          respostaInvalida = false;
          break;
        case "i wanna go to settings": 
          _irUIConfiguracao();
          respostaInvalida = false;
          break;
        case "go to settings": 
          _irUIConfiguracao();
          respostaInvalida = false;
          break;
        case "settings": 
          _irUIConfiguracao();
          respostaInvalida = false;
          break;

      
        case "i want to go to about us": 
          _irUISobre();
          respostaInvalida = false;
          break;
        case "i wanna go to about us": 
          _irUISobre();
          respostaInvalida = false;
          break;
        case "go to about us": 
          _irUISobre();
          respostaInvalida = false;
          break;
        case "about us": 
          _irUISobre();
          respostaInvalida = false;
          break;
        
        case "i want to go to devices ": 
          _irUIMenu(1);
          respostaInvalida = false;
          break;
        case "i wanna go to devices": 
          _irUIMenu(1);
          respostaInvalida = false;
          break;
        case "go to devices": 
          _irUIMenu(1);
          respostaInvalida = false;
          break;
        case "devices": 
          _irUIMenu(1);
          respostaInvalida = false;
          break;
        
        case "i wanna go to informations": 
          _irUIMenu(2);
          respostaInvalida = false;
          break;
        case "i want to go to informations": 
          _irUIMenu(2);
          respostaInvalida = false;
          break;
        case "go to informations": 
          _irUIMenu(2);
          respostaInvalida = false;
          break;
        case "informations": 
          _irUIMenu(2);
          respostaInvalida = false;
          break;
        
        case "i want to go to profile ":
          _irUIMenu(3);
          respostaInvalida = false;
          break;
        case "i wanna go to profile":
          _irUIMenu(3);
          respostaInvalida = false;
          break;
        case "go to profile ":
          _irUIMenu(3);
          respostaInvalida = false;
          break;
        case "profile":
          _irUIMenu(3);
          respostaInvalida = false;
          break;
      
        default:
          await speech.speak("I didn't hear you properly, which section do you want to go to?");
      }
    }
  }

  void _irUIMenu(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadScreen(index: index)
      )
    );
  }

  void _irUIConfiguracao() {
    Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Configuracao()),
        );
  }

  void _irUISobre() {
    Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Sobre())
        );
  }

  @override
  void initState() {
    super.initState();
    dialogo();
  }

  @override
  Widget build(BuildContext context) {
    // if(dialogoNaoInicializado) {
    //   dialogoNaoInicializado = false;
    //   dialogo();
    // }
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 300,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            top: 45,
            right: 16,
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.gear),
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Configuracao()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.circleInfo),
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    (Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Sobre()),
                    ));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Lista das interfaces do menu
final List<Widget> screens = [
  const HomeScreen(),
  const Devices(),
  const Dados(),
  const UserScreen(),
];