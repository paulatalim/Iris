import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'devices.dart';
import 'home.dart';
import 'dados.dart';
import 'perfil.dart';

int _index = 0;
bool trocarTela = false;

void mudarTela (int index) {
  print("chamo chamoooo $index");
  _index = index;

  trocarTela = true;
}

class Menubar extends StatefulWidget {
  int index;

  Menubar({required int index}): this.index = index;

  @override
  State<Menubar> createState() => _MenubarState();
}

class _MenubarState extends State<Menubar> {
  String resposta = '';
  late int currentIndex;
  
  // Colocar nomes das telas na lista
  final List<Widget> screens = [
    const HomeScreen(),
    const Devices(),
    const Dados(),
    const UserScreen(title: 'Nome Usuário'),
  ];

  final Color _colorIconPressed = const Color(0xFFA000FF);
  final Color _colorIconNotPressed = const Color(0xFF6B86EB);

  final List<Color> _colorIcon = [
    const Color(0xFFA000FF),
    const Color(0xFF6B86EB),
    const Color(0xFF6B86EB),
    const Color(0xFF6B86EB)
  ];

  final List<Color> _colorScreen = [
    const Color(0xFFbabdfa),
    const Color(0xFFdba0ff),
    const Color(0xFFDFE0FB),
    const Color(0xFFECCCFF),
    const Color(0XFFf1d9ff),
    const Color(0XFFe9edfc),
  ];

  void _colorSelection(int index) {
    print(currentIndex);
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
    
    currentIndex = widget.index;

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
                : _colorScreen[3],
            currentIndex == 0 || currentIndex == 1
                ? _colorScreen[1]
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
                      currentIndex = 0;
                      _colorSelection(currentIndex);
                    });
                  },
                ),
                IconButton(
                  color: _colorIcon[1],
                  icon: const Icon(FontAwesomeIcons.computer),
                  onPressed: () {
                    setState(() {
                      currentIndex = 1;
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
                      currentIndex = 2;
                      _colorSelection(currentIndex);
                    });
                  },
                ),
                IconButton(
                  color: _colorIcon[3],
                  icon: const Icon(FontAwesomeIcons.lock),
                  onPressed: () {
                    setState(() {
                      currentIndex = 3;
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
