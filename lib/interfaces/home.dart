import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import '../recurso_de_voz/speech_manager.dart';
import 'configuracao.dart';
import 'loading.dart';
import 'devices.dart';
import 'sobre.dart';
import 'dados.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool dialogoNaoInicializado = true;
  bool trocarUI = false;
  int index = 0;

  void _apresentacao() async {
    await Future.delayed(const Duration(seconds: 1));
    await speech.speak("Hi, I'm Iris, your virtual healthcare assistant");

    // Espera o recurso de voz ser inicializado
    while(speech.controlarPorVoz == null) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if(speech.controlarPorVoz) {
      _dialogo();
    }
  }

  void _dialogo() async {
    String resposta = "";
    bool respostaInvalida = true;

    await speech.speak("Which section of the app would you like to go to? Settings? About us? Devices? Or informations?");
    
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

    if(speech.controlarPorVoz == null) {
      _apresentacao();
    } else if (speech.controlarPorVoz!) {
      _dialogo();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                // IconButton(
                //   icon: const Icon(FontAwesomeIcons.gear),
                //   color: Colors.white,
                //   iconSize: 30,
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const Configuracao()),
                //     );
                //   },
                // ),
                // const SizedBox(height: 20),
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
];