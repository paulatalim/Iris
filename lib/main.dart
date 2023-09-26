import 'package:flutter/material.dart';

import 'menu.dart';

void main() {
  // Color minhaCorPersonalizada = Color(0xFF6A5ACD);

  runApp(MaterialApp(
    title: 'Iris',
    theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFdba0ff),
        )),
    debugShowCheckedModeBanner: false,
    home: const Menubar(),
  ));
}
