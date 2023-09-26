import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'loginmain.dart';
import 'perfil.dart';

class SingIn extends StatelessWidget {
  const SingIn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela Registro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(0XFF, 0x7C, 0x64, 0xEB)),
        useMaterial3: true,
      ),
      home: const UserSingIn(title: ''),
    );
  }
}

class UserSingIn extends StatefulWidget {
  const UserSingIn({super.key, required this.title});
  final String title;
  @override
  State<UserSingIn> createState() => _UserSingIn();
}

class _UserSingIn extends State<UserSingIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,

        //Menu de voltar ao menu (temporario)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TelaLogin()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        //Corpo principal
        child: Container(
            padding: const EdgeInsets.all(10),

            //Esqueleto do Corpo
            child: Column(
                //Vertical
                mainAxisAlignment: MainAxisAlignment.center,
                //Horizontal
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //Texto superior
                  Container(
                      height: 70,
                      child: Text(
                        'Criar um usuário',
                        style: GoogleFonts.dosis(fontSize: 30),
                      )),

                  //Imagem superior
                  Image.asset(
                    'assets/images/acc_finale.png',
                    width: 210.0,
                  ),

                  //Padding para formatação padronizada
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    child: Row(
                      //Vertical
                      crossAxisAlignment: CrossAxisAlignment.end,
                      //Horizontal
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      //Caixas de textos
                      children: [
                        //Caixa de Texto Nome
                        //Flexible necessario para realizar integração do TextFormField dentro de uma Row
                        Flexible(
                          child: TextFormField(
                            style: GoogleFonts.dosis(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              labelText: 'Nome:',
                            ),
                          ),
                        ),

                        //Container para realizar a separação das caixas de texto
                        Container(
                          width: 5,
                        ),

                        //Caixa de Texto Sobrenome
                        Flexible(
                          child: TextFormField(
                            style: GoogleFonts.dosis(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              labelText: 'Sobrenome:',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Coluna com demais caixas de texto
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Caixa de texto para e-mail
                      Padding(
                        //Padding para separar das caixas de texto superior - adicionando somente no eixo inferior
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                        child: TextFormField(
                          style: GoogleFonts.dosis(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            labelText: 'E-mail:',
                            hintText: 'nome@exemplo.com',
                          ),
                        ),
                      ),

                      //Caixa de texto para Senha
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                        child: TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            labelText: 'Senha:',
                          ),
                        ),
                      ),

                      //Caixa de texto para Confirmar senha
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                        child: TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            labelText: 'Confirme a senha:',
                          ),
                        ),
                      ),

                      //Botão de criação de conta
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UserScreen(title: 'Nome Usuário')),
                          );
                        },
                        style: ButtonStyle(
                            //Tamanho customizado para o botão
                            fixedSize:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Size(100, 50);
                              }
                              return Size(120, 50);
                            }),
                            //Cor de fundo customizada
                            backgroundColor: MaterialStateColor.resolveWith(
                                (context) =>
                                    Color.fromARGB(0XFF, 0x93, 0x7C, 0xEE))),
                        child: const Text(
                          //Botão para finalizar a criação da conta
                          'Criar',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ])),
      ),
    );
  }
}
