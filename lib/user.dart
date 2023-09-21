import 'package:flutter/material.dart';
import 'package:iris_app/creation.dart';

class User extends StatelessWidget {
  const User({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela Registro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(0XFF, 0x7C, 0x64, 0xEB)),
        useMaterial3: true,
      ),
      home: const UserScreen(title: ''),
    );
  }
}

class UserScreen extends StatefulWidget {
  const UserScreen({super.key, required this.title});
  final String title;
  @override
  State<UserScreen> createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,

        //Menu de voltar ao menu (temporario)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SingIn()),
            );
          },
        ),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text('Tela de usuario')],
      ),
    );
  }
}
