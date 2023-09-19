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

  final Color _iconColorPressed = Colors.red;
  final Color _iconColorNotPressed = Colors.green;

  Color _iconColor1 = Colors.green;
  Color _iconColor2 = Colors.green;
  Color _iconColor3 = Colors.green;
  Color _iconColor4 = Colors.green;

  // final List<Color> _iconColor = [
  //   Colors.green,
  //   Colors.green,
  //   Colors.green,
  //   Colors.green
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: tabs[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(FontAwesomeIcons.microphone),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      bottomNavigationBar: BottomAppBar(
          notchMargin: 6.0,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                color: _iconColor1,
                icon: const Icon(FontAwesomeIcons.house),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                    _iconColor1 = _iconColorPressed;
                    _iconColor2 = _iconColorNotPressed;
                    _iconColor3 = _iconColorNotPressed;
                    _iconColor4 = _iconColorNotPressed;
                  });
                },
              ),
              IconButton(
                color: _iconColor2,
                icon: const Icon(FontAwesomeIcons.computer),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                    _iconColor2 = _iconColorPressed;
                    _iconColor1 = _iconColorNotPressed;
                    _iconColor3 = _iconColorNotPressed;
                    _iconColor4 = _iconColorNotPressed;
                  });
                },
              ),

              //Espacamento entre icone e button action bar
              const SizedBox(
                width: 30,
              ),

              IconButton(
                color: _iconColor3,
                icon: const Icon(FontAwesomeIcons.heartPulse),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                    _iconColor3 = _iconColorPressed;
                    _iconColor1 = _iconColorNotPressed;
                    _iconColor2 = _iconColorNotPressed;
                    _iconColor4 = _iconColorNotPressed;
                  });
                },
              ),
              IconButton(
                color: _iconColor4,
                icon: const Icon(FontAwesomeIcons.lock),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                    _iconColor4 = _iconColorPressed;
                    _iconColor1 = _iconColorNotPressed;
                    _iconColor2 = _iconColorNotPressed;
                    _iconColor3 = _iconColorNotPressed;
                  });
                },
              ),
            ],
          )),
    );
  }
}
