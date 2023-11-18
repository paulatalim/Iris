import 'package:shared_preferences/shared_preferences.dart';
import 'usuario.dart';
import 'armazenamento.dart';

void setUserLoggedIn(String value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('email', value);
}

Future<bool> isUserLoggedIn() async {
  Armazenamento storage = Armazenamento();
  final prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email') ?? '';

  // Recupera os dados do usuario
  if (email.compareTo('') != 0) {
    List dados = await storage.buscarUsuario(email);

    // Verifica se o registro exite
    if (dados.isEmpty) {
      return Future.value(false);
    }

    usuario.id = dados[0]["id"]; //Carregando o ID
    usuario.nome = dados[0]["nome"]; //Carregando nome
    usuario.sobrenome = dados[0]["sobrenome"];
    usuario.email = email;

    dados = await storage.buscarInfoAdicional(usuario.id);
    usuario.peso = dados[0]["peso"];
    usuario.altura = dados[0]["altura"];
    usuario.temperatura = dados[0]["temperatura"];
    usuario.imc = dados[0]["imc"];

    return Future.value(true);
  }

  return Future.value(false);
}
