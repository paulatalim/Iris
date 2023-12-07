import 'dart:core';

/*
* Classe usuario contendo variáveis básicas para o utilização no app
*/
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
    _peso = 0;
    _altura = 0;
    _imc = 0;
    _temperatura = 0;
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
