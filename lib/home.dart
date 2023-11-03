import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'voices.dart';
import 'configuracao.dart';
import 'sobre.dart';
import 'main.dart';


RecursoDeVoz texto_home = RecursoDeVoz();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //texto_home .speek("Teste aplicativo iris ");
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
