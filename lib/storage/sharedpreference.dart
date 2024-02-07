import 'package:shared_preferences/shared_preferences.dart';

import 'armazenamento.dart';
import 'usuario.dart';

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

//Função para salvar temperatura no SharedPreference
void saveTemp(double temperatura) async {
  SharedPreferences tempStorage = await SharedPreferences.getInstance(); //Criando a instancia do SharedPreference
  tempStorage.setDouble('temperatura', temperatura); //Salvando o valor da temperatura na chave 'temperatura'
}

//Função para salvar altura no SharedPreference
void saveAltura(double altura) async {
  SharedPreferences altStorage = await SharedPreferences.getInstance(); //Criando a instancia do SharedPreference
  altStorage.setDouble('altura', altura); //Salvando o valor da temperatura na chave 'temperatura'
}

//Função para salvar peso no SharedPreference
void savePeso(double peso) async {
  SharedPreferences pesoStorage = await SharedPreferences.getInstance(); //Criando a instancia do SharedPreference
  pesoStorage.setDouble('peso', peso); //Salvando o valor da temperatura na chave 'temperatura'
}

//Função para salvar imc no SharedPreference
void saveIMC(double imc) async {
  SharedPreferences imcStorage = await SharedPreferences.getInstance(); //Criando a instancia do SharedPreference
  imcStorage.setDouble('imc', imc); //Salvando o valor da temperatura na chave 'temperatura'
}


//Função para resgatar temperatura do SharedPreference
Future<double> getTemp() async {
  SharedPreferences tempStorage = await SharedPreferences.getInstance(); //Criando a instancia do SharedPreference
  double tempArmazenada = tempStorage.getDouble('temperatura') ?? 0; //Localizando a chave e resgatando valor

  return Future.value(tempArmazenada);
}

//Função para resgatar altura do SharedPreference
Future<double> getAltura() async {
  SharedPreferences altStorage = await SharedPreferences.getInstance(); //Criando a instancia do SharedPreference
  double altArmazenada = altStorage.getDouble('altura') ?? 0; //Localizando a chave e resgatando valor

  return Future.value(altArmazenada);
}

//Função para resgatar peso do SharedPreference
Future<double> getPeso() async {
  SharedPreferences pesoStorage = await SharedPreferences.getInstance(); //Criando a instancia do SharedPreference
  double pesoArmazenada = pesoStorage.getDouble('peso') ?? 0; //Localizando a chave e resgatando valor

  return Future.value(pesoArmazenada);
}

//Função para resgatar imc do SharedPreference
Future<double> getImc() async {
  SharedPreferences imcStorage = await SharedPreferences.getInstance(); //Criando a instancia do SharedPreference
  double imcArmazenada = imcStorage.getDouble('imc') ?? 0; //Localizando a chave e resgatando valor

  return Future.value(imcArmazenada);
}