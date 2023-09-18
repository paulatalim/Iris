import 'package:flutter/material.dart';
import 'package:iris_app/main.dart';
import 'package:iris_app/loginmain.dart';

class SingIn extends StatelessWidget {
  const SingIn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela Registro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const UserSingIn(title: 'Criar uma conta'),
    );
  }
}

class UserSingIn extends StatefulWidget {
  const UserSingIn({super.key, required this.title});
  final String title;
  @override
  State<UserSingIn> createState() => _UserSingIn();
}

class _UserSingIn extends State<UserSingIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*
      * TELA DE SING-IN
      */
        );
  }
}
