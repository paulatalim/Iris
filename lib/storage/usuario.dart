import 'dart:core';
import 'dart:math';

import 'armazenamento.dart';

/// Classe usuario contendo variáveis básicas para o utilização no app
class User {
  late String nome;
  late String sobrenome;
  late int id;
  late String email;
  late double _peso;
  late double _altura;
  late double _imc;
  late double _temperatura;

  User() {
    nome = '';
    sobrenome = '';
    email = '';
    _peso = 0;
    _altura = 0;
    _imc = 0;
    _temperatura = 0;
  }

  /// Busca os dados no banco de dados atraves do [email] e os salva na memoria principal
  void importarDados (String email) async {
    Armazenamento storage = Armazenamento();

    // Recupera os dados do usuario
    List dados = await storage.buscarUsuario(email);
    if (dados.isNotEmpty){
      id = dados[0]["id"]; //Carregando o ID
      nome = dados[0]["nome"]; //Carregando nome
      sobrenome = dados[0]["sobrenome"];
      email = email;
    }

    List infoAdicionais = await storage.buscarInfoAdicional(id);
    if (infoAdicionais.isNotEmpty) {
      peso = infoAdicionais[0]["peso"];
      altura = infoAdicionais[0]["altura"];
      temperatura = infoAdicionais[0]["temperatura"];
      imc = infoAdicionais[0]["imc"];
    }
  }

  /// Calcula o imc do usuario
  void calcularImc() {
    if (_peso != 0 && _altura !=0) {
      _imc = peso / pow(_altura,2);
    }
  }

  get peso => _peso;
  set peso(value) => _peso = value;

  get altura => _altura;
  set altura(value) => _altura = value;

  get imc => _imc;
  set imc(value) => _imc = value;

  get temperatura => _temperatura;
  set temperatura(value) => _temperatura = value;
}

User usuario = User();
