import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'sharedpreference.dart';
import 'loginmain.dart';
import 'menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  bool isUserLoggedIn = false;

  runApp(MaterialApp(
    title: 'Iris',
    theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFdba0ff),
        )),
    debugShowCheckedModeBanner: false,
    home: isUserLoggedIn == true ? const Menubar() : const UserLogin(),
  ));
}
