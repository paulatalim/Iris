import 'dart:core';
import 'package:flutter/material.dart';

import 'cadastro.dart';
import 'menu.dart';
import '../storage/armazenamento.dart';
import '../storage/usuario.dart';
import '../storage/sharedpreference.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  Armazenamento storage = Armazenamento();

  //TextEdinting exclusivo para armazenar dados do usuario
  TextEditingController userAcc = TextEditingController(); // email
  TextEditingController userPss = TextEditingController(); // senha 

  //Mensagem vazia para realizar alteração caso necessário
  String mensagemErro = ''; 

  /// Redireciona a pagina para o menu
  void _redirecionarPaginaMenu() {
          
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Menu()),
      );
  }

  /// Realiza o login da conta no usuario
  void _login() async {
    String user = userAcc.text;
    String password = userPss.text;

    if (await storage.senhaCorreta(user, password) == false) {
      setState(() {
        mensagemErro = 'Usuario ou Senha inválidos.';
      });
    } else {
      debugPrint('login');
      
      // Salva os dados
      usuario.importarDados(user);
      setUserLoggedIn(user);

      _redirecionarPaginaMenu();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Color(0xFFDFE0FB),
              Color(0xFFECCCFF),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              //Vertical
              mainAxisAlignment: MainAxisAlignment.start,
              //Horizontal
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 85),
                Image.asset(
                  'assets/icon/logoIcone.png',
                  width: 190.0,
                ),
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    TextFormField(
                      controller: userAcc,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'E-mail:',
                        hintText: 'nome@exemplo.com',
                      ),
                    ),
                    TextFormField(
                      controller: userPss,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Senha:',
                        hintText: 'Digite sua senha',
                      ),
                    ),
                    Text(
                      mensagemErro,
                      style: const TextStyle(color: Colors.red),
                    )
                  ]),
                ),
                const SizedBox(height: 70),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    //Vertical
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //Horizontal
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserSingIn()),
                          );
                        },
                        child: const Text(
                          //Botão para criar uma conta (ainda a ser feito)
                          'Criar uma conta',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 56, 161, 214)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _login();
                        },
                        child: const Text(
                          //Botão para realizar login
                          'Entrar',
                          style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFF373B8A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
