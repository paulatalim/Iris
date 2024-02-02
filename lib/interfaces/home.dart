import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import '../recurso_de_voz/voices.dart';
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
  bool estado_mic = false;

 // void listen() async{
   // await voice.hear();
 // }
/*
   void listening() async {
    await voice.hear();
   }

   void dialogo() async {
     String resposta = "";
     bool respostaInvalida = true;

     await Future.delayed(const Duration(seconds: 5));

     await voice.speek("Para qual seção do aplicativo deseja ir? Configuração? Sobre? Dispositivos? Informações? Ou perfil?");
     await Future.delayed(const Duration(seconds: 10));
    
     while (respostaInvalida) {
       debugPrint("1");
       await voice.hear();
      
       resposta = voice.resposta;
       debugPrint(resposta);
       debugPrint(resposta.compareTo("sobre").toString());

       if (resposta.compareTo("configuração") == 0){
         irUIConfiguracao();
         respostaInvalida = false;
       }
       else if (resposta.compareTo("sobre") == 0) {
         irUISobre();
         respostaInvalida= false;
       }
       else if (resposta.compareTo("dispositivos") == 0) {
        
         irUIMenu(1);
         respostaInvalida= false;
      
       } else if (resposta.compareTo("informações") == 0) {
        
         irUIMenu(2);
         respostaInvalida= false;
      
       } else if (resposta.compareTo("perfil") == 0) {
         //index = 3;
         irUIMenu(3);
         respostaInvalida= false;
      
       } else {
         await voice.speek("Não te escutei direito, para qual seção deseja ir?");
         await Future.delayed(const Duration(seconds: 5));
         debugPrint("2");
       }
     }
     dialogoNaoInicializado = true;
   }
   */

  void irUIMenu (int index) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadScreen(index: index)
      )
    );
  }

  void irUIConfiguracao () {
    Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Configuracao()),
        );
  }

  void irUISobre () {
    Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Sobre())
        );
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