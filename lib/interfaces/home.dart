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
    await speech.speak("Para qual seção do aplicativo deseja ir? Configuração? Sobre? Dispositivos? Informações? Ou perfil?");
    
    while (respostaInvalida) {
      resposta = await speech.listen();
      
      switch (resposta) {
        case "configuração": 
          _irUIConfiguracao();
          respostaInvalida = false;
          break;
      
        case "sobre": 
          _irUISobre();
          respostaInvalida = false;
          break;
        
        case "dispositivos": 
          _irUIMenu(1);
          respostaInvalida = false;
          break;
        
        case "informações": 
          _irUIMenu(2);
          respostaInvalida = false;
          break;
        
        case "perfil":
          _irUIMenu(3);
          respostaInvalida = false;
          break;
      
        default:
          await speech.speak("Não te escutei direito, para qual seção deseja ir?");
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