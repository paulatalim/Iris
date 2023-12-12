import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import 'menu.dart';
import '../mqtt/state/MQTTAppState.dart';
import '../firebase_options.dart';
import '../storage/usuario.dart';

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

  usuario.nome = "Ilo";
  usuario.email = "iris@gmail.com";

  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    title: 'Iris',
    theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFdba0ff),
        )),
    debugShowCheckedModeBanner: false,
     home: ChangeNotifierProvider<MQTTAppState>(
          create: (_) => MQTTAppState(),
          child: Menu(),
        )
    // home: ChangeNotifierProvider<MQTTAppState>(
    //       create: (_) => MQTTAppState(),
    //       child: MainPage(),
    //     )
  ));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MainPage extends StatelessWidget{
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }
        else if(snapshot.hasError){
          return const Center(child: Text('Algo deu errado! Tente novamente mais tarde.'),);
        }
        if(snapshot.hasData){ //Verifica se usuario está logado
          return Menu(index: 0);
        }
        else{
          return const UserLogin();
        }
      },
    )
  );
}
