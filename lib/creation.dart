import 'package:flutter/material.dart';
import 'package:iris_app/loginmain.dart';
import 'package:iris_app/main.dart';

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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0XFF, 0x7C, 0x64, 0xEB),
        title: Text(widget.title),
        centerTitle: true,

        //Menu de voltar ao menu (temporario)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TelaLogin()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Row(
            //Vertical
            crossAxisAlignment: CrossAxisAlignment.center,
            //Horizontal
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Nome:',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Sobrenome:',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
