import 'package:flutter/material.dart';
import 'configuracao.dart';
import 'menu.dart';
import 'devices.dart';

import 'home.dart';

void main() {
  runApp(MaterialApp(
    title: 'Iris',
    theme: ThemeData(
      useMaterial3: true,
      // Define the default brightness and colors.
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple,
      ),
    ),
    debugShowCheckedModeBanner: false,
    home: const Configuracao(),
  ));
}
