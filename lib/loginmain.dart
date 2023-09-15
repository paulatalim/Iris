import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iris_app/main.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela Login/Registro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const UserLogin(title: 'Entrar'),       
    );
  }
}

class UserLogin extends StatefulWidget {
  const UserLogin({super.key , required this.title});
  final String title;
  @override
  State<UserLogin> createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {

  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.push(
              context, 
              CupertinoPageRoute(builder: (context) => const MyApp())
              );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center ,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TextFormField(
                decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'E-mail ou Usuário:',
                hintText: 'nome@exemplo.com',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Senha:',
                  hintText: 'Criar senha',

                ),
              ),
            ),

          ],
        ),
    );
  }
}