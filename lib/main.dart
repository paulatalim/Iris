import 'package:flutter/material.dart';

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
  final List<Widget> screens = [];

  final List<Center> tabs = [
    Center(child: const Text('Home')),
    Center(child: Text('elicoptero')),
    Center(child: Text('afonso')),
    Center(child: Text('genivaldo'))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            // icon: Icon(Icons.business),
            icon: ImageIcon(
              AssetImage("assets/images/sketch.png"),
              size: 20,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Aparelhos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Dados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Login',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.amber[800],
      ),
    );
  }
}
