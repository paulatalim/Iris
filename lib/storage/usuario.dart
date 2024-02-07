import 'dart:core';
import 'dart:math';

import 'package:iris_app/storage/sharedpreference.dart';

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
    id = 1;
    _peso = 0;
    _altura = 0;
    _imc = 0;
    _temperatura = 0;

    if(getAltura() != null){
      _altura = getAltura() as double;
    }

    if(getPeso() != null){
      _peso = getPeso() as double;
    }

    if(getTemp() != null){
      _temperatura = getTemp() as double;
    }
  }

  /// Calcula o imc do usuario
  void _calcularImc() {
    if (_peso != 0 && _altura !=0) {
      _imc = peso / pow(_altura,2);
      
      // TODO atualizar IMC no banco de dados
    }
  }

  /// Busca os dados no banco de dados atraves do [email] e os salva na memoria principal
  void importarDados(String email) async {
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

  /// Peso em kg do usuario
  get peso => _peso;
  set peso(value) {
    _peso = value;
    _calcularImc();

    savePeso(_peso);
  }

  /// Altura em metros do usuario
  get altura => _altura;
  set altura(value) {
    _altura = value;
    _calcularImc();

    saveAltura(_altura);
  }

  /// IMC do usuario
  get imc => _imc;

  /// Temperatura em graus Celsius do usuario
  get temperatura => _temperatura;
  set temperatura(value)  {
    _temperatura = value;

    saveTemp(_temperatura);
  }
}

User usuario = User();
