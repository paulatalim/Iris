import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/LOGO IRIS.jpeg',
                  width: 450,
                  height: 500,
                ),
                SizedBox(height: 20),
                Text(
                  "Clique para continuar",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16, 
            right: 16,
            child: Column(
              children: [
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    // Ação do primeiro ícone
                  },
                ),
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    // Ação do segundo ícone
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