import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'loginmain.dart';

class UserScreen extends StatefulWidget {
  final String title;

  const UserScreen({super.key, required this.title});

  @override
  State<UserScreen> createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {
  TextStyle styleBoxTitle() {
    return const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        color: Color(0xFF373B8A));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40),

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
                RawMaterialButton(
                    onPressed: () {},
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(15.0),
                    shape: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.person_add,
                        size: 110.0,
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 70),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Campo de texto Nome usuario
                Text(
                  "*Nome do usuário*",
                  style: GoogleFonts.dosis(
                    textStyle: styleBoxTitle(),
                  ),
                ),
                const SizedBox(height: 30),
                //Campo de texto Idade
                Text(
                  "Idade: -1",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.dosis(
                    textStyle: styleBoxTitle(),
                  ),
                ),
              ],
            )),

            const SizedBox(
              height: 70,
            ),

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
                          return Size(100, 50);
                        }
                        return Size(190, 50);
                      }),
                      //Cor de fundo customizada
                      backgroundColor: MaterialStateColor.resolveWith(
                          (context) => Color.fromARGB(0XFF, 0x93, 0x7C, 0xEE))),
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

            Container(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
