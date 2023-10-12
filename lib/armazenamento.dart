import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'dart:convert';

class Armazenamento {
  late Database db;
  late String caminhoBancoDados;
  late String localBancoDados;

  Armazenamento() {
    if (db == null) {
      _initdb();
    }
    _recuperarBancoDados();
  }

  void _initdb() async {
    db = await _recuperarBancoDados();
    caminhoBancoDados = await getDatabasesPath();
    localBancoDados = join(caminhoBancoDados, "banco3.db");
  }

  dynamic _recuperarBancoDados() async {
    db = await openDatabase(
      localBancoDados, version: 1,
      onCreate: _onCreate,
      //   onCreate: (db, dbVersaoRecente) {
      // String sql =
      //     "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER) ";
      // db.execute(sql);
    );
  }

  _onCreate(db, version) async {
    await db.execute(_conta);
  }

  dynamic _salvarDados(String nome, String email, String senha) async {
    Database db = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {"nome": nome, "idade": idade};
    int id = await db.insert("usuarios", dadosUsuario);
    print("Salvo: $id ");
  }

  dynamic _listarUsuarios() async {
    Database db = await _recuperarBancoDados();
    String sql = "SELECT * FROM usuarios";
    //String sql = "SELECT * FROM usuarios WHERE idade=58";
    //String sql = "SELECT * FROM usuarios WHERE idade >=30 AND idade <=58";
    //String sql = "SELECT * FROM usuarios WHERE idade BETWEEN 18 AND 58";
    //String sql = "SELECT * FROM usuarios WHERE nome='Maria Silva'";
    List usuarios =
        await db.rawQuery(sql); //conseguimos escrever a query que quisermos
    for (var usu in usuarios) {
      print(
          " id: ${usu['id'].toString()} nome: ${usu['nome']} idade: ${usu['idade'].toString()}");
    }
  }

  dynamic _listarUmUsuario(int id) async {
    Database db = await _recuperarBancoDados();
    List usuarios = await db.query("usuarios",
        columns: ["id", "nome", "idade"], where: "id = ?", whereArgs: [id]);
    for (var usu in usuarios) {
      print(
          " id: ${usu['id'].toString()} nome: ${usu['nome']} idade: ${usu['idade'].toString()}");
    }
  }

  _excluirUsuario(int id) async {
    Database db = await _recuperarBancoDados();
    int retorno = await db.delete("usuarios",
        where: "id = ?", //caracter curinga
        whereArgs: [id]);
    print("Itens excluidos: " + retorno.toString());
  }

  dynamic _atualizarUsuario(int id) async {
    Database db = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome": "Antonio Pedro",
      "idade": 35,
    };
    int retorno = await db.update("usuarios", dadosUsuario,
        where: "id = ?", //caracter curinga
        whereArgs: [id]);
    print("Itens atualizados: " + retorno.toString());
  }

  /// Criptografa informacoes sensiveis
  dynamic criptografar(var atribute) {
    Hash hasher = md5;

    // Converte a varivel para string e depois para bytes
    var bytes = utf8.encode(atribute.toString());

    // Criptografa os bytes na criptografia MD5
    var digest = md5.convert(bytes);

    return digest;
  }

  /// Busca o usuario atraves do email e retorna seu id
  void buscarUsuario() {}
}
