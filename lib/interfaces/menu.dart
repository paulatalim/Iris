import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'devices.dart';
import 'home.dart';
import 'dados.dart';
import 'perfil.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _currentIndex = 0;

  final Color _iconColorPressed = const Color(0xFFA000FF);
  final Color _iconColorNotPressed = const Color(0xFF6B86EB);

  // Lista das paginas contidas no menu
  final List<Widget> screens = [
    const HomeScreen(),
    const Devices(),
    const Dados(),
    const UserScreen(title: 'Nome Usuário'),
  ];

  // Lista das cores dos icones no menu
  final List<Color> _iconColor = [
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
    const Color(0XFFf1d9ff),
    const Color(0XFFe9edfc),
  ];

  /// verifica o icone selecionado no menu e altera suas cores
  void _colorSelection(int index) {
    for (int i = 0; i < _iconColor.length; i++) {
      if (i != index) {
        _iconColor[i] = _iconColorNotPressed;
      } else {
        _iconColor[i] = _iconColorPressed;
      }
    }
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
            _currentIndex == 0
                ? _colorScreen[0]
                : _currentIndex == 1
                    ? _colorScreen[5]
                    : _colorScreen[3],
            _currentIndex == 0
                ? _colorScreen[1]
                : _currentIndex == 1
                    ? _colorScreen[4]
                    : _colorScreen[2]
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: screens[_currentIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AvatarGlow(
          animate: true,
          glowColor: Colors.green,
          endRadius: 45,
          duration: const Duration(milliseconds: 1000),
          repeatPauseDuration: const Duration(milliseconds: 1000),
          repeat: true,
          child: SizedBox(
            width: 52,
            height: 52,
            child: FloatingActionButton(
                onPressed: () {},
                elevation: 0,
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                child: const Icon(
                  FontAwesomeIcons.microphone,
                  size: 22,
                )),
          ),
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
                color: _iconColor[0],
                icon: const Icon(FontAwesomeIcons.house),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                    _colorSelection(_currentIndex);
                  });
                },
              ),
              IconButton(
                color: _iconColor[1],
                icon: const Icon(FontAwesomeIcons.computer),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                    _colorSelection(_currentIndex);
                  });
                },
              ),

              //Espacamento entre icone e button action bar
              const SizedBox(
                width: 90,
              ),

              IconButton(
                color: _iconColor[2],
                icon: const Icon(FontAwesomeIcons.heartPulse),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                    _colorSelection(_currentIndex);
                  });
                },
              ),
              IconButton(
                color: _iconColor[3],
                icon: const Icon(FontAwesomeIcons.lock),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                    _colorSelection(_currentIndex);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
