import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../google_sing_in.dart';

import 'main.dart';
import 'cadastro.dart';
import 'menu.dart';
import '../storage/armazenamento.dart';
import '../storage/usuario.dart';
import '../voices.dart';


class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  Armazenamento storage = Armazenamento();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //TextEdinting exclusivo para armazenar dados do usuario
  TextEditingController userAcc = TextEditingController(); // email
  TextEditingController userPss = TextEditingController(); // senha 

  String mensagemErro =
      ''; //Mensagem vazia para realizar alteração caso necessário
  
  Future login() async{
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => const Center(child: CircularProgressIndicator(),)
    );
    try{
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim());
        List userLoad;
        userLoad = await storage.buscarUsuario(emailController.text.trim()); //Carregando o usuario existente
        usuario.id = userLoad[0]["id"]; //Carregando o ID
        usuario.nome = userLoad[0]["nome"]; //Carregando nome
        print("User nome: " + usuario.nome); 
        print("DB nome: " + userLoad[0]["nome"]);
        usuario.sobrenome = userLoad[0]["sobrenome"]; //Carregando sobrenome
        usuario.email = emailController.text.trim(); //Carregando e-mail
    } on FirebaseAuthException catch (e){
      setState(() {
        erroEmail = '';
        erroSenha = '';
      });
      if(e.code == 'invalid-email' || e.code == 'user-not-found'){
        setState(() {
          erroEmail = 'E-mail inválido';
        });
      }
      else if(e.code == 'invalid-credential'){
        setState(() {
          erroSenha = 'Senha errada';
        });
      }
      else print(e.code);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String erroEmail = '';
  String erroSenha = '';
  
  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
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
        builder: (context) => Menu(index: 0),
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
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        helperText: erroEmail,
                        helperStyle: const TextStyle(color: Color.fromARGB(255, 220, 0, 0)),
                        border: const UnderlineInputBorder(),
                        labelText: 'E-mail:',
                        hintText: 'nome@exemplo.com',
                      ),
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        helperText: erroSenha,
                        helperStyle: const TextStyle(color: Color.fromARGB(255, 220, 0, 0)),
                        border: const UnderlineInputBorder(),
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
                          login();
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
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.purple, 
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                  onPressed: () {
                    signInWithGoogle().then((result){
                      if (result != null){
                        navigatorKey.currentState!.popUntil((route) => route.isFirst);
                      }
                    });
                  },   
                  icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red,), 
                  label: const Text('Entrar com o Google'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
