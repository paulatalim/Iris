import 'package:flutter/material.dart';

import 'devices.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color minhaCorPersonalizada = Color(0xFF6A5ACD); // Lavanda
    Color minhaCorEscura = Color(0xFF483D8B); // Lavanda Escuro

    return MaterialApp(
      home: Scaffold(
        body: MyHomePage(minhaCorPersonalizada, minhaCorEscura),
      ),
    );
  }
}
