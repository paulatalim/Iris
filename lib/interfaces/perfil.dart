import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../storage/usuario.dart';
import '../voices.dart';
import '../control.dart';
import 'login.dart';

class UserScreen extends StatefulWidget {
  final String title;

  const UserScreen({super.key, required this.title});

  @override
  State<UserScreen> createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {
  String resposta = "";
  bool respostaInvalida = true;
  bool dialogoNaoInicializado = true;

  /// Estiliza textos na pagina
  TextStyle styleBoxTitle() {
    return GoogleFonts.dosis(
      textStyle: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        color: Color(0xFF373B8A),
      ),
    );
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const UserLogin()));
  }

  void dialogo() async {
    await voice.speek("Sobre o seu perfil. Você se chama NOME e seu email é EMAIL. Você deseja sair da sua conta?");
    await Future.delayed(Duration(seconds: 10));

    while (respostaInvalida) {
        await voice.hear();
        resposta = voice.resposta;
        resposta = resposta.toLowerCase().trim();

        if (resposta.compareTo("sim") == 0) {
          irUILogin();
        } else if (resposta.compareTo("não") == 0) {
        
          respostaInvalida = false;
        } else {
          await voice.speek("Hummm não te escutei direito, repete de novo?");
          await Future.delayed(Duration(seconds: 5));
        }
    }

    await voice.speek("Para qual seção deseja ir agora?");
    await Future.delayed(Duration(seconds: 5));
    respostaInvalida = true;

    while (respostaInvalida) {
      await voice.hear();
      resposta = voice.resposta;
      resposta = resposta.toLowerCase().trim();
      
      if (resposta.compareTo("menu principal") == 0) {
        irUIMenu(0);
      } else if (resposta.compareTo("dispositivos") == 0) {
        irUIMenu(1);
        
      } else if (resposta.compareTo("informações") == 0) {
        irUIMenu(2);
        
      } else if (resposta.compareTo("perfil") == 0) {
        await voice.speek("Você já está nessa seção, me diga outra seção. Caso estiver com dúvida de qual opção deseja, escolha a seção do menu principal. Então para qual seção deseja ir agora?");
        await Future.delayed(Duration(seconds: 5));
      } else {
        await voice.speek("Hummm não te escutei direito, repete de novo?");
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }

  void irUIMenu (int index) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ControlScreen(index: index)
      )
    );
  }

  void irUILogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const UserLogin()),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    
    if(dialogoNaoInicializado) {
      dialogoNaoInicializado = false;
      dialogo();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        //Esqueleto do Corpo
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          //Corpo
          children: <Widget>[
            const SizedBox(height: 100),
            //Botão de adição de imagem
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Campo de texto Nome usuario
                    Text(
                      usuario.nome + ' ' + usuario.sobrenome,
                      style: styleBoxTitle(),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      usuario.email,
                      style: styleBoxTitle(),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                RawMaterialButton(
                    onPressed: () {},
                    elevation: 10.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(15.0),
                    shape: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.person,
                        color: Color(0xFF373B8A),
                        size: 110.0,
                      ),
                    )),
              ],
            ),

            const SizedBox(height: 90),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Botão para edição de conta
                TextButton(
                  onPressed: () {/*Adicionar rota para função*/},
                  style: ButtonStyle(
                      //Tamanho customizado para o botão
                      fixedSize: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Size(100, 50);
                        }
                        return const Size(190, 50);
                      }),
                      //Cor de fundo customizada
                      backgroundColor: MaterialStateColor.resolveWith(
                          (context) => const Color(0xFFA000FF))),
                  child: const Text(
                    'Editar Perfil',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                //Botão para realizar log-off
                TextButton(
                  onPressed: (){
                    _signOut();
                  },
                  child: const Text(
                    'Sair',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
