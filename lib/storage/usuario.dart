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
      this.email = email;
    }

    List infoAdicionais = await storage.buscarInfoAdicional(id);
    if (infoAdicionais.isNotEmpty) {
      _peso = infoAdicionais[0]["peso"];
      _altura = infoAdicionais[0]["altura"];
      _temperatura = infoAdicionais[0]["temperatura"];
      _imc = infoAdicionais[0]["imc"];
    }
  }

  /// Calcula o imc do usuario
  void _calcularImc() {
    if (_peso != 0 && _altura !=0) {
      _imc = peso / pow(_altura,2);
      // TODO atualizar IMC no banco de dados
    }
  }

  get peso => _peso;
  set peso(value) {
    _peso = value;
    _calcularImc();

    // TODO atualizar peso no banco de dados
  }

  get altura => _altura;
  set altura(value) {
    _altura = value;
    _calcularImc();

    // TODO atualizar altura no banco de dados
  }

  get imc => _imc;

  get temperatura => _temperatura;
  set temperatura(value)  {
    _temperatura = value;

    // TODO atualizar temperatura no banco de dados
  }
}

User usuario = User();
