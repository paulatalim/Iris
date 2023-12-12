import 'package:shared_preferences/shared_preferences.dart';
import 'usuario.dart';
import 'armazenamento.dart';

/// Altera ou cria um campo com o valor [value] no shared preference
void setUserLoggedIn(String value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('email', value);
}

/// Verifica se um campo existe, caso existir os dados sao salvos na 
/// memoria principale possui retorno [true], caso contrario, retorna [false]
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

    // Salva os dados na memoria principal
    usuario.importarDados(email);

    return Future.value(true);
  }

  return Future.value(false);
}
