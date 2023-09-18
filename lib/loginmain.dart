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
  const UserLogin({super.key, required this.title});
  final String title;
  @override
  State<UserLogin> createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => const MyApp()));
            },
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 70.0,
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
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      //Botão para realizar login
                      'Entrar',
                      style: TextStyle(fontSize: 30, color: Colors.lightBlue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      //Botão para criar uma conta (ainda a ser feito)
                      'Crie uma conta.',
                      style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                      textAlign:
                          TextAlign.left, //Align não funciona no widget Text
                    ),
                  )
                ],
              ),
            ),
          ));
        }));
  }
}
