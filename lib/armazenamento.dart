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

    // Abre e cria a tabela
    database = await openDatabase(localBancoDados, version: 1,
        onCreate: (database, databaseVersaoRecente) {
      database.execute(conta);
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
    print("Salvo: $id ");

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
      print(
          " id: ${usu['id'].toString()} nome: ${usu['nome']} email: ${usu['email'].toString()}");
    }
  }

  dynamic listarUmUsuario(int id) async {
    List usuarios = await database!.query("usuarios",
        columns: ["id", "nome", "idade"], where: "id = ?", whereArgs: [id]);
    for (var usu in usuarios) {
      print(
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
    print("Itens excluidos: " + retorno.toString());
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
    print("Itens atualizados: " + retorno.toString());
  }

  /// Busca o usuario atraves do email e retorna seu id
  Future<List> buscarUsuario(String email) async {
    String criptoEmail = _criptografar(email);
    List usuarios = await database!.query("usuarios",
        columns: ["id", "nome", "senha"],
        where: "email = ?",
        whereArgs: [criptoEmail]);
    // for (var usu in usuarios) {
    //   print(
    //       " id: ${usu['id'].toString()} nome: ${usu['nome']} email: ${usu['email'].toString()}");
    // }

    return Future.value(usuarios);
  }

  Future<bool> senhaCorreta(String email, String senha) async {
    String senhaCripto = _criptografar(senha);
    String emailCripto = _criptografar(email);

    List usuario = await buscarUsuario(email);

    if (usuario[2].toString().compareTo(senhaCripto) == 0) {
      return Future.value(true);
    }

    return Future.value(false);
  }
}
