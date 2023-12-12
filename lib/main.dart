import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'sharedpreference.dart';
import 'loginmain.dart';
import 'menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  bool isLogged = await isUserLoggedIn();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFFE6E6E6),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(MaterialApp(
    title: 'Iris',
    theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFdba0ff),
        )),
    debugShowCheckedModeBanner: false,
    home: isLogged == true ? Menubar(index: 0) : const UserLogin(),
  ));
}
