import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'dart:convert';

class Armazenamento {
  static Database? database;
  late String caminhoBancoDados;
  late String localBancoDados;

  Armazenamento() {
    if (database == null) {
      _initdatabase();
    }
  }

  /// Inicializa o banco de dados, resgatando dados antigos caso existir
  Future<void> _initdatabase() async {
    caminhoBancoDados = await getDatabasesPath();
    localBancoDados = join(caminhoBancoDados, "dados.db");
    database = await _recuperarBancoDados();
  }

  /// Cria e abre as tabelas do banco de dados
  dynamic _recuperarBancoDados() async {
    // Codigo SQL para criar a tabela de usuario
    String conta = '''CREATE TABLE usuarios (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          nome VARCHAR,
          sobrenome VARCHAR,
          email VARCHAR, 
          senha VARCHAR
        );''';

    // Codigo SQL para criar a tabela de informações adicionais com chave estrangeira
    String infoAdicional = '''CREATE TABLE informacoes_adicionais (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          peso REAL,
          temperatura REAL,
          altura REAL,
          imc REAL,
          usuario_id INTEGER,
          FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
        );''';

    // Abre e cria a tabela
    database = await openDatabase(localBancoDados, version: 1,
        onCreate: (database, databaseVersaoRecente) {
      database.execute(conta);
      database.execute(infoAdicional);
    });

    return database;
  }

  /// Criptografa informacoes sensiveis,
  /// retona o [atribute], criptografado
  String _criptografar(var atribute) {
    // Converte a varivel para string e depois para bytes
    var bytes = utf8.encode(atribute.toString());

    // Criptografa os bytes na criptografia MD5
    var digest = md5.convert(bytes);

    return digest.toString();
  }

  /// Salva os dados [nome], [sobrenome], [email] e [senha] em uma nova linha no 
  /// banco de dados, inicializa as informacoes adicionais como 0 e retorna o id do usuario
  Future<int> salvarDados(
      String nome, String sobrenome, String email, String senha) async {
    // Verifica se ja ha registro do email do usuario
    List usuario = await buscarUsuario(email);
    if (usuario.isNotEmpty) {
      return -1;
    }

    database = _recuperarBancoDados();

    // Criptografa as informacoes sensiveis
    var criptoEmail = _criptografar(email);
    var criptoSenha = _criptografar(senha);

    // Adiciona as informacoes a um objeto
    Map<String, dynamic> dadosUsuario = {
      "nome": nome,
      "sobrenome": sobrenome,
      "email": criptoEmail.toString(),
      "senha": criptoSenha.toString()
    };

    // Adiciona informacao no banco de dados
    int id = await database!.insert("usuarios", dadosUsuario);
    debugPrint("Salvo: $id ");

    // Adiciona as informacoes adinais zeradas
    Map<String, dynamic> dadosInfoAdicional = {
      "usuario_id": id,
      "peso": 0,
      "temperatura": 0,
      "altura": 0,
      "imc": 0,
    };

    // Adiciona informacoes no banco de dados
    await database!.insert("informacoes_adicionais", dadosInfoAdicional);

    return Future.value(id);
  }

  /// Atualiza os dados do usuario
  dynamic atualizarUsuario(
      int id, 
      String nome, 
      String sobrenome, 
      String email, 
      String senha) async {

    database = _recuperarBancoDados();

    String emailCripto = _criptografar(email);
    String senhaCripto = _criptografar(senha);

    Map<String, dynamic> dadosUsuario = {
      "nome": nome,
      "sobrenome": sobrenome,
      "email": emailCripto,
      "senha": senhaCripto
    };
    int retorno = await database!.update("usuarios", dadosUsuario,
        where: "id = ?", //caracter curinga
        whereArgs: [id]);
    debugPrint("Itens atualizados: ${retorno.toString()}");
  }

  /// Atualiza as informacoes adicionais do usuario do [id] no dados do usuario
  Future<void> atualizarInfoAdicional(int id, double peso, double temperatura,
      double altura, double imc) async {
    
    database = _recuperarBancoDados();

    Map<String, dynamic> dadosInfoAdicional = {
      "peso": peso,
      "temperatura": temperatura,
      "altura": altura,
      "imc": imc,
    };

    int retorno = await database!.update(
        "informacoes_adicionais", dadosInfoAdicional,
        where: "id = ?", whereArgs: [id]);
    debugPrint("Info Adicional Atualizada: $retorno");
  }

  /// Pesquisa no banco de dados atraves do [id] as informacoes adicionais
  Future<List> buscarInfoAdicional(int id) async {
    database = _recuperarBancoDados();
    List infoAdicional = await database!.query("informacoes_adicionais",
        columns: ["peso", "temperatura", "altura", "imc"],
        where: "usuario_id = ?",
        whereArgs: [id]);

    return Future.value(infoAdicional);
  }

  /// Busca o usuario atraves do [email] e retorna uma lista com suas
  /// informações ou vazia, caso não encontre o registro
  Future<List> buscarUsuario(String email) async {
    dynamic criptoEmail = _criptografar(email);

    if (database == null) {
      await _initdatabase();
    }

    List usuarios = await database!.query("usuarios",
        columns: ["id", "nome", "sobrenome", "senha"],
        where: "email = ?",
        whereArgs: [criptoEmail.toString()]);

    return Future.value(usuarios);
  }

  /// Valida a senha do usuario, retorna [true] caso senha e email estejam
  /// corretos e [false] caso não encontre o email ou a senha estiver incorreta
  Future<bool> senhaCorreta(String email, String senha) async {
    dynamic senhaCripto = _criptografar(senha);
    List usuario = await buscarUsuario(email);

    // Caso nao encontrar a senha
    if (usuario.isEmpty) {
      return false;
    
    } else if (usuario[0]["senha"].toString().compareTo(senhaCripto.toString()) == 0) {
      return Future.value(true);
    }

    return Future.value(false);
  }
}
