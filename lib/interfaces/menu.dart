import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import 'devices.dart';
import 'home.dart';
import 'dados.dart';
import 'perfil.dart';

@immutable
class Menu extends StatefulWidget {
  const Menu({super.key, required this.index});

  final int index;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool variavelNaoInicializada = true;
  String resposta = '';
  
  late int currentIndex;
  late int index;
  
  final Color _colorIconPressed = const Color(0xFFA000FF);
  final Color _colorIconNotPressed = const Color(0xFF6B86EB);

  /// Lista das paginas contidas no menu
  final List<Widget> screens = [
    const HomeScreen(),
    const Devices(),
    const Dados(),
    const UserScreen(),
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

  @override
  Widget build(BuildContext context) {
    
    if (variavelNaoInicializada) {
      currentIndex = widget.index;
      index = widget.index;
      variavelNaoInicializada = false;
    } else {
      currentIndex = index;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          // Seciona a cor de fundo de acordo com as telas
          colors: [
            currentIndex == 0 || currentIndex == 1
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
          backgroundColor: Colors.green,
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
                IconButton(
                  color: _colorIcon[0],
                  icon: const Icon(FontAwesomeIcons.house),
                  onPressed: () {
                    setState(() {
                      index = 0;
                      _colorSelection(currentIndex);
                    });
                  },
                ),
                IconButton(
                  color: _colorIcon[1],
                  icon: const Icon(FontAwesomeIcons.computer),
                  onPressed: () {
                    setState(() {
                      index = 1;
                      _colorSelection(currentIndex);
                    });
                  },
                ),

                //Espacamento entre icone e button action bar
                const SizedBox(
                  width: 30,
                ),

                IconButton(
                  color: _colorIcon[2],
                  icon: const Icon(FontAwesomeIcons.heartPulse),
                  onPressed: () {
                    setState(() {
                      index = 2;
                      _colorSelection(currentIndex);
                    });
                  },
                ),
                IconButton(
                  color: _colorIcon[3],
                  icon: const Icon(FontAwesomeIcons.lock),
                  onPressed: () {
                    setState(() {
                      index = 3;
                      _colorSelection(currentIndex);
                    });
                  },
                ),
              ],
            )),
      ),
    );
  }
}
