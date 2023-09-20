import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(const HomeApp());

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  // Colocar nomes das telas na lista
  // final List<Widget> screens = [];

  final List<Center> tabs = [
    const Center(child: Text('home')),
    const Center(child: Text('dispositivos')),
    const Center(child: Text('dados')),
    const Center(child: Text('login'))
  ];

  final Color _iconColorPressed = const Color(0xFFA000FF);
  final Color _iconColorNotPressed = const Color(0xFF6B86EB);

  final List<Color> _iconColor = [
    const Color(0xFFA000FF),
    const Color(0xFF6B86EB),
    const Color(0xFF6B86EB),
    const Color(0xFF6B86EB)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        child: const Icon(FontAwesomeIcons.microphone),
      ),
      bottomNavigationBar: BottomAppBar(
          color: const Color(0xFFE6E6E6),
          notchMargin: 6.0,
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
                    for (int i = 0; i < _iconColor.length; i++) {
                      if (i != _currentIndex) {
                        _iconColor[i] = _iconColorNotPressed;
                      } else {
                        _iconColor[i] = _iconColorPressed;
                      }
                    }
                  });
                },
              ),
              IconButton(
                color: _iconColor[1],
                icon: const Icon(FontAwesomeIcons.computer),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                    for (int i = 0; i < _iconColor.length; i++) {
                      if (i != _currentIndex) {
                        _iconColor[i] = _iconColorNotPressed;
                      } else {
                        _iconColor[i] = _iconColorPressed;
                      }
                    }
                  });
                },
              ),

              //Espacamento entre icone e button action bar
              const SizedBox(
                width: 30,
              ),

              IconButton(
                color: _iconColor[2],
                icon: const Icon(FontAwesomeIcons.heartPulse),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                    for (int i = 0; i < _iconColor.length; i++) {
                      if (i != _currentIndex) {
                        _iconColor[i] = _iconColorNotPressed;
                      } else {
                        _iconColor[i] = _iconColorPressed;
                      }
                    }
                  });
                },
              ),
              IconButton(
                color: _iconColor[3],
                icon: const Icon(FontAwesomeIcons.lock),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                    for (int i = 0; i < _iconColor.length; i++) {
                      if (i != _currentIndex) {
                        _iconColor[i] = _iconColorNotPressed;
                      } else {
                        _iconColor[i] = _iconColorPressed;
                      }
                    }
                  });
                },
              ),
            ],
          )),
    );
  }
}
