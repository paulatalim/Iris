import 'package:flutter/material.dart';
import 'package:iris_app/loginmain.dart';

import 'loginmain.dart';

import 'menu.dart';

void main() {
  // Color minhaCorPersonalizada = Color(0xFF6A5ACD);

  runApp(MaterialApp(
    title: 'Iris',
    theme: ThemeData(
      useMaterial3: true,
      // Define the default brightness and colors.
      // colorScheme: ColorScheme.fromSwatch(
      //   primarySwatch: Colors.deepPurple,
      //   accentColor: minhaCorPersonalizada,
      // ),
    ),
    debugShowCheckedModeBanner: false,
    home: const Menubar(),
  ));
}
