import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  const UserLogin({super.key, required this.title});
  final String title;
  @override
  State<UserLogin> createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Barra superior com botões (temporarios) de menu e outros
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          centerTitle: true,
          //Menu de voltar ao menu (temporario)
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
          actions: [
            //Botao enfeite (somente temporario)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              //Vertical
              mainAxisAlignment: MainAxisAlignment.start,
              //Horizontal
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 50,
                ),
                Image.asset(
                  'assets/images/sketch.png',
                  width: 190.0,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'E-mail ou Usuário:',
                      hintText: 'nome@exemplo.com',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Senha:',
                      hintText: 'Digite sua senha',
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //Horizontal
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          //Botão para criar uma conta (ainda a ser feito)
                          'Crie uma conta.',
                          style:
                              TextStyle(fontSize: 14, color: Colors.blueGrey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          //Botão para realizar login
                          'Entrar',
                          style:
                              TextStyle(fontSize: 30, color: Colors.lightBlue),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
