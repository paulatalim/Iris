import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iris_app/sharedpreference.dart';

import 'loginmain.dart';
import 'usuario.dart';

class UserScreen extends StatefulWidget {
  final String title;

  const UserScreen({super.key, required this.title});

  @override
  State<UserScreen> createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {
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
                      usuario.nome,
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
                  onPressed: () {
                    setUserLoggedIn('');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserLogin()),
                    );
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
