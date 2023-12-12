import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'voices.dart';
import 'configuracao.dart';
import 'sobre.dart';
import 'menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String resposta = "";
  bool respostaInvalida = true;

  void listening() async {
    resposta = await voice.hear();
  }

  @override
  Widget build(BuildContext context) {

    voice.speek("Para qual seção do aplicativo deseja ir? Configuração? Sobre? Dispositivos? Informações? Ou perfil?");

    while (respostaInvalida) {
      // listening();
      // resposta = resposta.toLowerCase().trim();

      // if (resposta.compareTo("configuração") == 0){
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => const Configuracao()),
      //   );
      //   respostaInvalida = false;
      // }
    //   else if (resposta.compareTo("sobre") == 0) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => const Sobre())
    //     );
    //     respostaInvalida= false;
    //   }
    //   else if (resposta.compareTo("dispositivos") == 0) {
    //     setState(() {
    //       currentIndex = 1;
    //     });
    //     respostaInvalida= false;
      
    //   } else if (resposta.compareTo("informações") == 0) {
    //     setState(() {
    //       currentIndex = 2;
    //     });
    //     respostaInvalida= false;
      
    //   } else if (resposta.compareTo("perfil") == 0) {
    //     setState(() {
    //       currentIndex = 3;
    //     });
    //     respostaInvalida= false;
      
    //   } else {
    //     voice.speek("Hummm não te escutei direito, o que você quer que eu meça?");
    //   }
    }



    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 230,
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
    );
  }
}
