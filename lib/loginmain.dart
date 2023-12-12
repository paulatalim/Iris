import 'dart:core';
import 'package:flutter/material.dart';

import 'cadastro.dart';
import 'menu.dart';
import 'armazenamento.dart';
import 'usuario.dart';
import 'sharedpreference.dart';
import 'voices.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  Armazenamento storage = Armazenamento();

  TextEditingController userAcc =
      TextEditingController(); //TextEdinting exclusivo para armazenar a conta do usuario
  TextEditingController userPss =
      TextEditingController(); //TextEdinting exclusivo para armazenar a senha do usuario

  String mensagemErro =
      ''; //Mensagem vazia para realizar alteração caso necessário

  void _login() async {
    String user = userAcc.text;
    String password = userPss.text;

    if (await storage.senhaCorreta(user, password) == false) {
      setState(() {
        mensagemErro = 'Usuario ou Senha inválidos.';
      });
    } else {
      debugPrint('login');
      List userLoad;
      userLoad =
          await storage.buscarUsuario(user); //Carregando o usuario existente
      usuario.id = userLoad[0]["id"]; //Carregando o ID
      usuario.nome = userLoad[0]["nome"]; //Carregando nome
      usuario.sobrenome = userLoad[0]["sobrenome"];
      usuario.email = user; //Carregando e-mail

      setUserLoggedIn(user);

      irUIMenu();
    }
  }

  String resposta = "";
  bool respostaInvalida = true;
  
  bool dialogoNaoInicializado = true;

  void questionarCampo (String campo, String pronome) async {
    bool infoErrada = true;
    
    resposta = "";
    voice.speek("Qual a $pronome $campo?");

    while (infoErrada) {
      await voice.hear();
      resposta = voice.resposta;
      while (respostaInvalida) {
        voice.speek("$resposta, esse é $pronome $campo?");
        if (resposta.toLowerCase().trim().compareTo("sim") == 0) {
          respostaInvalida = false;
          infoErrada = false;
          
        } else if (resposta.toLowerCase().trim().compareTo("não") == 0) {
          break;
        }
        voice.speek("Hummm não te escutei direito, repete de novo?");
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }

  void dialogo() async {
    voice.speek("Entre com a sua conta ou crie uma nova conta! Voce já possui uma conta aqui?");
    await Future.delayed(Duration(seconds: 5));
    await voice.hear();
      resposta = voice.resposta;

    while(respostaInvalida) {
      if (resposta.toLowerCase().trim().compareTo("sim") == 0) {
        respostaInvalida = false;
        //Ir menu
      } else if (resposta.toLowerCase().trim().compareTo("não") == 0) {
        irUICadastro();
        respostaInvalida = false;
      }

      voice.speek("Hummm não te escutei direito, repete de novo?");
      await Future.delayed(Duration(seconds: 5));
    }

    questionarCampo("email", "seu");
    questionarCampo("senha", "sua");

    irUIMenu();
  }

  void irUICadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const UserSingIn()),
    );
  }

  void irUIMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Menubar(index: 0),
      ));
  }

  @override
  Widget build(BuildContext context) {

    if(dialogoNaoInicializado) {
      dialogoNaoInicializado = false;
      dialogo();
    }

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
