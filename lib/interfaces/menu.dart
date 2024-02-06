import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import '../recurso_de_voz/speech_manager.dart';
import 'devices.dart';
import 'home.dart';
import 'dados.dart';
import 'configuracao.dart';
// import 'perfil.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, this.index});

  final int? index;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool variavelNaoInicializada = true;
  late bool _isRunning;
  bool _microphneActive = false;
  String resposta = '';
  
  late int currentIndex;
  
  final Color _colorIconPressed = const Color(0xFFA000FF);
  final Color _colorIconNotPressed = const Color(0xFF6B86EB);

  /// Lista das paginas contidas no menu
  final List<Widget> screens = [
    const HomeScreen(),
    const Devices(),
    const Dados(),
    const Configuracao(),
  ];

  /// Lista de cores do icones do menu
  final List<Color> _colorIcon = [
    const Color(0xFFA000FF),
    const Color(0xFF6B86EB),
    const Color(0xFF6B86EB),
    const Color(0xFF6B86EB)
  ];

  // Lista das cares de fundo das paginas
  final List<Color> _colorScreen = [
    const Color(0xFFbabdfa),
    const Color(0xFFdba0ff),
    const Color(0xFFDFE0FB),
    const Color(0xFFECCCFF),
    const Color(0XFFe9edfc),
    const Color(0XFFf1d9ff),
  ];

  /// Verifica o icone selecionado no menu e altera suas cores
  void _colorSelection(int index) {
    debugPrint(currentIndex.toString());
    for (int i = 0; i < _colorIcon.length; i++) {
      if (i != index) {
        _colorIcon[i] = _colorIconNotPressed;
      } else {
        _colorIcon[i] = _colorIconPressed;
      }
    }
  }

  void _updateColorMicrophone() async {
    while(_isRunning) {
      setState(() {
        _microphneActive = speech.microphoneOn;
      });
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index ?? 0;
    _isRunning = true;
    _colorSelection(currentIndex);
    _updateColorMicrophone();
  }

  @override
  void dispose() {
    super.dispose();
    _isRunning = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          // Seciona a cor de fundo de acordo com as telas
          colors: [
            currentIndex < 2
                ? _colorScreen[0]
                : currentIndex == 1
                    ? _colorScreen[4]
                    : _colorScreen[3],
            currentIndex == 0
                ? _colorScreen[1]
                : currentIndex == 1
                    ? _colorScreen[5]
                    : _colorScreen[2]
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: screens[currentIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor:  _microphneActive ? Colors.green : Colors.red,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(FontAwesomeIcons.microphone),
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xFFE6E6E6),
          height: 0.08 * MediaQuery.of(context).size.height,
          notchMargin: 6.0,
          padding: const EdgeInsets.all(0),
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buttonNavigationBar(0, FontAwesomeIcons.house),
              buttonNavigationBar(1, FontAwesomeIcons.computer),

              //Espacamento entre icone e button action bar
              const SizedBox(
                width: 30,
              ),

              buttonNavigationBar(2, FontAwesomeIcons.heartPulse),
              buttonNavigationBar(3, FontAwesomeIcons.gear)
            ],
          )
        ),
      ),
    );
  }

  Widget buttonNavigationBar(int index, IconData icon) {
    return IconButton(
      color: _colorIcon[index],
      icon: Icon(icon),
      onPressed: () {
        setState(() {
          currentIndex = index;
          _colorSelection(currentIndex);
        });
      },
    );
  }
}
