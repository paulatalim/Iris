import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../recurso_de_voz/speech_manager.dart';
import '../storage/usuario.dart';
import 'loading.dart';
import 'login.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

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

  /// Desloga da conta do usuario
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    _singOutPageChange();
  }

  /// Troca de interfaces quendo o usuario desloga da conta
  void _singOutPageChange() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const UserLogin()));
  }

  void _dialogo() async {
    await speech.speak("Sobre o seu perfil. Você se chama NOME e seu email é EMAIL. Você deseja sair da sua conta?");

    while (respostaInvalida) {
        resposta = await speech.listen();

        switch (resposta) {
          case "sim":
            _irUILogin();
            break;
          
          case "não":
            respostaInvalida = false;
            break;
          
          default:
            await speech.speak("Hummm não te escutei direito, repete de novo?");
        }
    }

    await speech.speak("Para qual seção deseja ir agora?");
    respostaInvalida = true;

    while (respostaInvalida) {
      resposta = await speech.listen();
      switch(resposta) {
        case "menu principal":
          _irUIMenu(0);
          break;

        case "dispositivos":
          _irUIMenu(1);
          break;

        case "informações":
          _irUIMenu(2);
          break;

        case "perfil":
          await speech.speak("Você já está nessa seção, me diga outra seção. Caso estiver com dúvida de qual opção deseja, escolha a seção do menu principal. Então para qual seção deseja ir agora?");
          break;
          
        default:
          await speech.speak("Hummm não te escutei direito, repete de novo?");
      }
    }
  }

  void _irUIMenu(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadScreen(index: index)
      )
    );
  }

  void _irUILogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const UserLogin()),
    );
  }

  @override
  void initState() {
    super.initState();
    _dialogo();
  }
 
  @override
  Widget build(BuildContext context) {

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
                      "${usuario.nome} ${usuario.sobrenome}",
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
                  child: Text(
                    AppLocalizations.of(context)!.editarPerfil,
                    style: const TextStyle(fontSize: 25, color: Colors.white),
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
                  child: Text(
                    AppLocalizations.of(context)!.sair,
                    style: const TextStyle(fontSize: 20, color: Colors.red),
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
