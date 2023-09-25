import 'package:flutter/material.dart';

import 'configuracao.dart';
import 'menu.dart';
import 'devices.dart';
import 'home.dart';
import 'sobre.dart';

void main() {
  Color minhaCorPersonalizada = Color(0xFF6A5ACD);

  runApp(MaterialApp(
    title: 'Iris',
    theme: ThemeData(
      useMaterial3: true,
      // Define the default brightness and colors.
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.deepPurple,
        accentColor: minhaCorPersonalizada,
      ),
    ),
    debugShowCheckedModeBanner: false,
    home: const Menubar(),

    // home: MyHomePage(
    //   title: 'About us',
    //   corLavandaEscura: Color(0xFF483D8B),
    //   corLavandaClaro: Color(0xFFB49CDC),
    // ),
  ));
}
