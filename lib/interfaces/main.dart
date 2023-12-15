import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// import 'login.dart';
// import 'menu.dart';
// import '../mqtt/state/MQTTAppState.dart';
import '../firebase_options.dart';
// import '../storage/usuario.dart';
import 'firebase_control_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFFddd9e0),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    title: 'Iris',
    theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFdba0ff),
        )),
    debugShowCheckedModeBanner: false,
    home: const MainPage(),
    //  home: ChangeNotifierProvider<MQTTAppState>(
    //       create: (_) => MQTTAppState(),
    //       child: Menu(index: 0),
        // )
    // home: ChangeNotifierProvider<MQTTAppState>(
    //       create: (_) => MQTTAppState(),
    //       child: MainPage(),
    //     )
  ));
}
