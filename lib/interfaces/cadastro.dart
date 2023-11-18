import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../storage/armazenamento.dart';
import '../storage/usuario.dart';
import 'login.dart';
import 'menu.dart';
import '../storage/sharedpreference.dart';

class UserSingIn extends StatefulWidget {
  const UserSingIn({super.key});
  // final String title;
  @override
  State<UserSingIn> createState() => _UserSingIn();
}

class _UserSingIn extends State<UserSingIn> {
  Armazenamento storage = Armazenamento();

  // Armazena os dados do usuarios
  TextEditingController userAcc = TextEditingController(); // conta
  TextEditingController userPss1 = TextEditingController(); // senha
  TextEditingController userPss2 = TextEditingController(); // segunda senha
  TextEditingController userName = TextEditingController(); // nome
  TextEditingController userSurname = TextEditingController(); // sobremenome

  //Mensagem vazia para realizar alteração caso necessário
  String erroCadastro = ''; 

  /// Cria conta de usuario e depois redireciona a pagina para o menu
  void _criarUser() {
    // Salva os dados no banco de dados
    storage.salvarDados(
        usuario.nome, userSurname.text, userAcc.text, userPss1.text);

    // Salva os dados no armazenamento local
    setUserLoggedIn(userAcc.text);

    // Salva os dados na memoria principal
    usuario.importarDados(userAcc.text);

    //Redirecionando ao menu
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Menu()),
    );
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
        erroCadastro = 'Verifique se o e-mail está correto.';
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
        erroCadastro =
            'A senha deve conter pelo menos 8 digitos, possuindo uma letra maiúscula, uma letra minúscula e um número.';
      });
    }
  }

  /// Verifica se as senhas inseridas sao equivalentes
  void validarSenha() {
    if (userPss1.text.compareTo(userPss2.text) == 0) {
      checarSenha();
    } else {
      setState(() {
        erroCadastro = 'As senhas devem ser iguais.';
      });
    }
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
                  SizedBox(
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
                            controller: userName,
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
                            controller: userSurname,
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
                          controller: userPss2,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            labelText: 'Confirme a senha:',
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
                ]
              )
            ),
      ),
    );
  }
}
