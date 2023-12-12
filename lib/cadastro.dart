
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'voices.dart';
import 'loginmain.dart';
import 'menu.dart';

class UserSingIn extends StatefulWidget {
  const UserSingIn({super.key});

  @override
  State<UserSingIn> createState() => _UserSingIn();
}

class _UserSingIn extends State<UserSingIn> {
  String resposta = "";
  bool respostaInvalida = true;
  bool infoErrada = true;

  void questionarCampo(String campo) async {
    resposta = "";
    await voice.speek("Agora me fale seu $campo");
    await Future.delayed(Duration(seconds: 5));

    while (infoErrada) {
      await voice.hear();
      resposta = voice.resposta;

      while (respostaInvalida) {
        await voice.speek("$resposta, esse é seu $campo?");
        if (resposta.toLowerCase().trim().compareTo("sim") == 0) {
          respostaInvalida = false;
          infoErrada = false;
          
        } else if (resposta.toLowerCase().trim().compareTo("não") == 0) {
          break;
        }
        await voice.speek("Hummm não te escutei direito, repete de novo?");
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }

  void dialogo() async {
    await voice.speek("Tudo bem, vamos fazer uma conta para você. Primeiro eu preciso que me fale seu primeiro nome");
    await Future.delayed(Duration(seconds: 5));

    while (infoErrada) {
      resposta = "";
      respostaInvalida = true;
      infoErrada = true;

      resposta = voice.resposta;

      while (respostaInvalida) {
        await voice.speek("$resposta, esse é seu nome?");
        await Future.delayed(Duration(seconds: 5));

        if (resposta.toLowerCase().trim().compareTo("sim") == 0) {
          respostaInvalida = false;
          infoErrada = false;
          
        } else if (resposta.toLowerCase().trim().compareTo("não") == 0) {
          break;
        }
        await voice.speek("Hummm não te escutei direito, repete de novo?");
        await Future.delayed(Duration(seconds: 5));
      }
    }

    questionarCampo("sobrenome");
    questionarCampo("email");
    questionarCampo("senha");

    irUIMenu();
  }

  bool dialogoNaoInicializado = true;

  void irUIMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Menubar(index: 0)),
    );
  }
  
  @override
  Widget build(BuildContext context) {

    if(dialogoNaoInicializado) {
      dialogoNaoInicializado = false;
      dialogo();
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        //Menu de voltar ao menu (temporario)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserLogin()),
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
                            keyboardType: TextInputType.name,
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
                        const SizedBox(
                          width: 5,
                        ),

                        //Caixa de Texto Sobrenome
                        Flexible(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
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
                          keyboardType: TextInputType.emailAddress,
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              irUIMenu();
                            },
                            style: ButtonStyle(
                                //Tamanho customizado para o botão
                                fixedSize:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return const Size(100, 50);
                                  }
                                  return const Size(120, 50);
                                }),
                                //Cor de fundo customizada
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (context) => const Color.fromARGB(
                                        0XFF, 0x93, 0x7C, 0xEE))),
                            child: const Text(
                              //Botão para finalizar a criação da conta
                              'Criar',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ])),
      ),
    );
  }
}
