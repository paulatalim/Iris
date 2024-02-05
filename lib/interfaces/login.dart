import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import '../recurso_de_voz/speech_manager.dart';
import '../storage/armazenamento.dart';
import '../storage/usuario.dart';
import '../firebase/google_sing_in.dart';
import 'cadastro.dart';
import '../main.dart';
import 'menu.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  Armazenamento storage = Armazenamento();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String erroEmail = '';
  String erroSenha = '';

  // Mensagem vazia para realizar alteração caso necessário
  String mensagemErro = ''; 
  
  Future login() async {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => const Center(child: CircularProgressIndicator(),)
    );
    try{
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
      );

      List userLoad;
      userLoad = await storage.buscarUsuario(emailController.text.trim()); //Carregando o usuario existente
      usuario.id = userLoad[0]["id"]; //Carregando o ID
      usuario.nome = userLoad[0]["nome"]; //Carregando nome
      usuario.sobrenome = userLoad[0]["sobrenome"]; //Carregando sobrenome
      usuario.email = emailController.text.trim(); //Carregando e-mail

      debugPrint("User nome: ${usuario.nome}"); 
      debugPrint("DB nome: ${userLoad[0]["nome"]}");
    
    } on FirebaseAuthException catch (e){
      setState(() {
        erroEmail = '';
        erroSenha = '';
      });
      
      if(e.code == 'invalid-email' || e.code == 'user-not-found'){
        setState(() {
          erroEmail = 'E-mail inválido';
        });
      } else if(e.code == 'invalid-credential'){
        setState(() {
          erroSenha = 'Senha inválida';
        });
      } else {
        debugPrint(e.code);
      }
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  void questionarCampo(String campo, String pronome) async {
    bool infoErrada = true;
    bool respostaInvalida = true;
    
    String resposta = "";
    await speech.speak("Qual a $pronome $campo?");

    while (infoErrada) {
      respostaInvalida = true;
      resposta = await speech.listen();
      
      while (respostaInvalida) {
        await speech.speak("$resposta, esse é $pronome $campo?");

        switch (resposta) {
          case "sim":
            respostaInvalida = false;
            infoErrada = false;
            break;
          
          case "não":
            respostaInvalida = false;
            break;
          default:
            await speech.speak("Hummm não te escutei direito, repete de novo?");
        }
      }
    }
  }

  void _dialogo() async {
    String resposta = "";
    bool respostaInvalida = true;

    await speech.speak("Entre com a sua conta ou crie uma nova conta! Voce já possui uma conta aqui?");
    resposta = await speech.listen();

    while(respostaInvalida) {
      switch (resposta) {
          case "sim":
            // Fazer login
            // _irUIMenu();
            respostaInvalida = false;
            break;
          
          case "não":
            _irUICadastro();
            break;
          
          default:
            await speech.speak("Hummm não te escutei direito, repete de novo?");
        }
    }

    questionarCampo("email", "seu");
    questionarCampo("senha", "sua");

    _irUIMenu();
  }

  void _irUICadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const UserSingIn()),
    );
  }

  void _irUIMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Menu(),
      ));
  }

  @override
  void initState() {
    super.initState();
    _dialogo();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 85),
                Image.asset(
                  'assets/icon/logo.png',
                  width: 150.0,
                ),
                const SizedBox(height: 50),
                
                // Campos de entrada de informacoes do usuario
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        helperText: erroEmail,
                        helperStyle: const TextStyle(color: Color.fromARGB(255, 220, 0, 0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Senha:',
                        hintText: 'Digite sua senha',
                      ),
                    ),

                    mensagemErro.compareTo('') != 0 ? Text(
                        mensagemErro,
                        style: const TextStyle(color: Colors.red, fontSize: 25),
                      ): const SizedBox(height: 0,)
                  ]), 
                ),
                const SizedBox(height: 40,),
                
                // Botão para realizar login
                GestureDetector(
                  onDoubleTap: () => login(),
                  child: Container(
                   alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    width: 0.8 * MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(90, 0, 0, 0),
                          blurRadius: 5,
                          offset: Offset(0, 5))],
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF7C64EB),
                          Color(0xFFA000FF),
                        ],
                      ),
                    ),
                    child: 
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                
                // Botão para realizar login com google
                GestureDetector(
                  onTap: () {
                    signInWithGoogle().then((result){
                        if (result.compareTo('') != 0){
                          navigatorKey.currentState!.popUntil((route) => route.isFirst);
                        }
                      });
                  },
                  child: Container(
                    width: 0.8 * MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(90, 0, 0, 0),
                          blurRadius: 5,
                          offset: Offset(0, 5))],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.network(
                          'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/google/google-original.svg',
                          height: 25,
                        ),
                        const SizedBox(width: 20,),
                        const Text(
                          'Entrar com o Google', 
                          style: TextStyle(
                            fontSize: 22,
                            color: Color(0xFF202124),
                          ),
                        ),
                    ]),
                  )
                ),
                
                const SizedBox(height: 50,),
                
                // Botao para cadastrar
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserSingIn()),
                      );
                  },
                  child: Container(
                    width: 0.8 * MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(color: const Color(0xFF373B8A), ),
                    ),
                    child: const Text(
                      "Criar conta",
                      style: TextStyle(
                        color: Color(0xFF373B8A),
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      )
                    ),
                  ),
                )
              ],
            )
          )
        ),
      ),
    );
  }
}
