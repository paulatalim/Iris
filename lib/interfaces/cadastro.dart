import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../recurso_de_voz/speech_manager.dart';
import '../storage/armazenamento.dart';
import '../storage/usuario.dart';
// import '../main.dart';
import 'login.dart';
import 'menu.dart';

class SingUp extends StatefulWidget {
  const SingUp({super.key});
  
  @override
  State<SingUp> createState() => _SingUp();
}

class _SingUp extends State<SingUp> {
  Armazenamento storage = Armazenamento();

  // Armazena os dados do usuarios
  TextEditingController userAcc = TextEditingController(); // conta
  TextEditingController userPss1 = TextEditingController(); // senha
  TextEditingController userPss2 = TextEditingController(); // segunda senha
  TextEditingController userName = TextEditingController(); // nome
  TextEditingController userSurname = TextEditingController(); // sobremenome

  //Mensagem vazia para realizar alteração caso necessário
  String erroCadastro = '';

  String resposta = "";
  bool respostaInvalida = true;
  bool infoErrada = true;

  /// Criando usuario dentro do firebase ccom as informações providenciadas
  void _criarUser() async {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => const Center(child: CircularProgressIndicator(),)
    );

    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userAcc.text.trim(), 
        password: userPss1.text.trim(),
      );
    } on FirebaseAuthException catch (e){
      debugPrint(e.toString());
    }
    storage.salvarDados(userName.text.trim(), userSurname.text.trim(), userAcc.text.trim(), "");
    usuario.email = userAcc.text;
    usuario.sobrenome = userSurname.text;
    usuario.nome = userName.text;
    // navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  /// Valida o email
  void checarEmail() {
    String email = userAcc.text;

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (emailValid) {
      //É um e-mail válido
      checarSenha();
    } else {
      setState(() {
        erroCadastro = AppLocalizations.of(context)!.errorRegisterEmail;
      });
    }
  }

  /// Valida a nova senha
  void checarSenha() {
    String password = userPss1.text;

    bool hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    bool hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    bool hasDigits = RegExp(r'\d').hasMatch(password);
    int hasLenght = password.length;

    if (hasUppercase && hasLowercase && hasDigits && hasLenght >= 8) {
      // A senha possui pelo menos uma letra maiúscula, uma letra minúscula e um número
      _criarUser();
    } else {
      setState(() {
        erroCadastro = AppLocalizations.of(context)!.errorRegisterPassword1;
      });
    }
  }

  /// Verifica se as senhas inseridas sao equivalentes
  void validarSenha() {
    if (userPss1.text.compareTo(userPss2.text) == 0) {
      checarSenha();
    } else {
      setState(() {
        erroCadastro = AppLocalizations.of(context)!.errorRegisterPassword2;
      });
    }
  }

  void _questionarCampo(String campo) async {
    resposta = "";
    await speech.speak("Agora me fale seu $campo");

    while (infoErrada) {
      resposta = await speech.listen();

      while (respostaInvalida) {
        await speech.speak("$resposta, esse é seu $campo?");

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
    await speech.speak("Tudo bem, vamos fazer uma conta para você. Primeiro eu preciso que me fale seu primeiro nome");

    while (infoErrada) {
      resposta = "";
      respostaInvalida = true;
      infoErrada = true;

      resposta = await speech.listen();

      while (respostaInvalida) {
        await speech.speak("$resposta, esse é seu nome?");

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

    _questionarCampo("sobrenome");
    _questionarCampo("email");
    _questionarCampo("senha");

    _irUIMenu();
  }

  void _irUIMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const Menu()),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        //Menu de voltar ao menu (temporario)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const UserLogin()));
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
                  SizedBox(
                      height: 70,
                      child: Text(
                        AppLocalizations.of(context)!.register,
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
                            controller: userName,
                            keyboardType: TextInputType.name,
                            style: GoogleFonts.dosis(),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              labelText: "${AppLocalizations.of(context)!.name}:",
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
                            controller: userSurname,
                            keyboardType: TextInputType.name,
                            style: GoogleFonts.dosis(),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              labelText: "${AppLocalizations.of(context)!.surname}:",
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
                          controller: userAcc,
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
                          controller: userPss1,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            labelText: "${AppLocalizations.of(context)!.password}:",
                          ),
                        ),
                      ),

                      //Caixa de texto para Confirmar senha
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                        child: TextFormField(
                          controller: userPss2,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            labelText: '${AppLocalizations.of(context)!.confirmPassword}:',
                          ),
                        ),
                      ),

                      //Caixa de texto que aparecerá uma mensagem caso as senhas estejam erradas
                      Text(
                        erroCadastro,
                        style: const TextStyle(color: Colors.red),
                      ),

                      //Botão de criação de conta
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              validarSenha();
                            },
                            style: ButtonStyle(
                                //Tamanho customizado para o botão
                                fixedSize:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return const Size(250, 50);
                                  }
                                  return const Size(300, 50);
                                }),
                                //Cor de fundo customizada
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (context) => const Color.fromARGB(
                                        0XFF, 0x93, 0x7C, 0xEE))),
                            child: Text(
                              //Botão para finalizar a criação da conta
                              AppLocalizations.of(context)!.createAccount,
                              style:
                                  const TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ]
              )
            ),
      ),
    );
  }
}
