import 'package:flutter/material.dart';

import 'sobre.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color minhaCorPersonalizada = Color(0xFF6A5ACD); // Lavanda
    // Substituído corClara por corLavandaClaro

    return MaterialApp(
      title: 'Iris',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple, // Cor primária
          accentColor: minhaCorPersonalizada, // Cor de destaque personalizada
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'About us',
        corLavanda: Color(0xFF6A5ACD),
        corLavandaEscura: Color(0xFF483D8B),
        corLavandaClaro: Color(0xFFB49CDC),
      ),
    );
  }
}
