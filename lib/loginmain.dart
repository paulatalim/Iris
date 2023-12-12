import 'package:flutter/material.dart';
import 'cadastro.dart';
import 'menu.dart';
import 'voices.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  String resposta = "";
  bool respostaInvalida = true;
  bool infoErrada = true;

  void listening() async {
    resposta = await voice.hear();
  }

  void questionarCampo (String campo, String pronome) {
    resposta = "";
    voice.speek("Qual a $pronome $campo?");

    while (infoErrada) {
      listening();
      while (respostaInvalida) {
        voice.speek("$resposta, esse é $pronome $campo?");
        if (resposta.toLowerCase().trim().compareTo("sim") == 0) {
          respostaInvalida = false;
          infoErrada = false;
          
        } else if (resposta.toLowerCase().trim().compareTo("não") == 0) {
          break;
        }
        voice.speek("Hummm não te escutei direito, repete de novo?");
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    voice.speek("Entre com a sua conta ou crie uma nova conta!");
    voice.speek("Voce já possui uma conta aqui?");
    listening();

    while(respostaInvalida) {
      if (resposta.toLowerCase().trim().compareTo("sim") == 0) {
        respostaInvalida = false;
        //Ir menu
      } else if (resposta.toLowerCase().trim().compareTo("não") == 0) {
        // Ir para tela cadastro
        respostaInvalida = false;
      }

      voice.speek("Hummm não te escutei direito, repete de novo?");
    }

    questionarCampo("email", "seu");
    questionarCampo("senha", "sua");

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
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'E-mail ou Usuário:',
                        hintText: 'nome@exemplo.com',
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Senha:',
                        hintText: 'Digite sua senha',
                      ),
                    ),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Menubar(),
                              ));
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
