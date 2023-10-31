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
      _recuperarBancoDados();
    }
  }

  void _initdatabase() async {
    database = await _recuperarBancoDados();
    caminhoBancoDados = await getDatabasesPath();
    localBancoDados = join(caminhoBancoDados, "banco3.database");
  }

  dynamic _recuperarBancoDados() async {
    // Codigo SQL para criar a tabela
    String conta = '''CREATE TABLE usuarios (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          nome VARCHAR, 
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
  }

  /// Criptografa informacoes sensiveis
  dynamic _criptografar(var atribute) {
    // Converte a varivel para string e depois para bytes
    var bytes = utf8.encode(atribute.toString());

    // Criptografa os bytes na criptografia MD5
    var digest = md5.convert(bytes);

    return digest;
  }

  Future<int> salvarDados(String nome, String email, String senha) async {
    // Verifica se ja ha registro do email do usuario
    List usuario = await buscarUsuario(email);
    if (usuario.isNotEmpty) {
      return -1;
    }

    // Criptografa as informacoes sensiveis
    var criptoEmail = _criptografar(email);
    var criptoSenha = _criptografar(senha);

    // Adiciona as informacoes a um objeto
    Map<String, dynamic> dadosUsuario = {
      "nome": nome,
      "email": criptoEmail,
      "senha": criptoSenha
    };

    // Adiciona informacao no banco de dados
    int id = await database!.insert("usuarios", dadosUsuario);
    debugPrint("Salvo: $id ");

    return Future.value(id);
  }

  Future<int> salvarInfoAdicional(int usuarioId, double peso, double temperatura, double altura, double imc) async {
  Map<String, dynamic> dadosInfoAdicional = {
    "usuario_id": usuarioId,
    "peso": peso,
    "temperatura": temperatura,
    "altura": altura,
    "imc": imc,
  };

  int id = await database!.insert("informacoes_adicionais", dadosInfoAdicional);
  print("Info Adicional Salva: $id");

  return Future.value(id);
}

  dynamic listarUsuarios() async {
    String sql = "SELECT * FROM usuarios";
    //String sql = "SELECT * FROM usuarios WHERE idade=58";
    //String sql = "SELECT * FROM usuarios WHERE idade >=30 AND idade <=58";
    //String sql = "SELECT * FROM usuarios WHERE idade BETWEEN 18 AND 58";
    //String sql = "SELECT * FROM usuarios WHERE nome='Maria Silva'";
    List usuarios = await database!
        .rawQuery(sql); //conseguimos escrever a query que quisermos
    for (var usu in usuarios) {
      debugPrint(
          " id: ${usu['id'].toString()} nome: ${usu['nome']} email: ${usu['email'].toString()}");
    }
  }

  dynamic listarUmUsuario(int id) async {
    List usuarios = await database!.query("usuarios",
        columns: ["id", "nome", "idade"], where: "id = ?", whereArgs: [id]);
    for (var usu in usuarios) {
      debugPrint(
          " id: ${usu['id'].toString()} nome: ${usu['nome']} email: ${usu['email'].toString()}");
    }
  }

  excluirUsuario(String email) async {
    // Cripotografa o email a ser buscado
    String criptoEmail = _criptografar(email);

    // Busca e exclusão de registro aprtir do email
    int retorno = await database!.delete("usuarios",
        where: "email = ?", //caracter curinga
        whereArgs: [criptoEmail]);
    debugPrint("Itens excluidos: ${retorno.toString()}");
  }

  dynamic atualizarUsuario(
      int id, String nome, String email, String senha) async {
    String emailCripto = _criptografar(email);
    String senhaCripto = _criptografar(senha);

    Map<String, dynamic> dadosUsuario = {
      "nome": nome,
      "email": emailCripto,
      "senha": senhaCripto
    };
    int retorno = await database!.update("usuarios", dadosUsuario,
        where: "id = ?", //caracter curinga
        whereArgs: [id]);
    debugPrint("Itens atualizados: ${retorno.toString()}");
  }

  Future<void> atualizarInfoAdicional(int id, double peso, double temperatura, double altura, double imc) async {
  Map<String, dynamic> dadosInfoAdicional = {
    "peso": peso,
    "temperatura": temperatura,
    "altura": altura,
    "imc": imc,
  };

  int retorno = await database!.update("informacoes_adicionais", dadosInfoAdicional,
      where: "id = ?", whereArgs: [id]);
  print("Info Adicional Atualizada: $retorno");
}

  Future<List<Map<String, dynamic>>> buscarInfoAdicional(int usuarioId) async {
  String sql = "SELECT * FROM informacoes_adicionais WHERE usuario_id = ?";
  List<Map<String, dynamic>> infoAdicional = await database!.rawQuery(sql, [usuarioId]);

  return Future.value(infoAdicional);
}

  /// Busca o usuario atraves do [email] e retorna uma lista com suas
  /// informações ou vazia, caso não encontre o registro
  Future<List> buscarUsuario(String email) async {
    String criptoEmail = _criptografar(email);
    List usuarios = await database!.query("usuarios",
        columns: ["id", "nome", "senha"],
        where: "email = ?",
        whereArgs: [criptoEmail]);

    return Future.value(usuarios);
  }

  /// Valida a senha do usuario, retorna [true] caso senha e email estejam
  /// corretos e [false] caso não encontre o email ou a senha estiver incorreta
  Future<bool> senhaCorreta(String email, String senha) async {
    String senhaCripto = _criptografar(senha);
    List usuario = await buscarUsuario(email);

    // Caso nao encontrar a senha
    if (usuario.isEmpty) {
      return false;
    }

    if (usuario[2].toString().compareTo(senhaCripto) == 0) {
      return Future.value(true);
    }

    return Future.value(false);
  }
}
