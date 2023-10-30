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
      // _recuperarBancoDados();
    }
  }

  void _initdatabase() async {
    caminhoBancoDados = await getDatabasesPath();
    localBancoDados = join(caminhoBancoDados, "dados.db");
    database = await _recuperarBancoDados();
  }

  dynamic _recuperarBancoDados() async {
    // Codigo SQL para criar a tabela
    String conta = '''CREATE TABLE usuarios (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          nome VARCHAR,
          sobrenome VARCHAR,
          email VARCHAR, 
          senha VARCHAR
        );''';

    // Abre e cria a tabela
    database = await openDatabase(localBancoDados, version: 1,
        onCreate: (database, databaseVersaoRecente) {
      database.execute(conta);
    });

    return database;
  }

  /// Criptografa informacoes sensiveis
  dynamic _criptografar(var atribute) {
    // Converte a varivel para string e depois para bytes
    var bytes = utf8.encode(atribute.toString());

    // Criptografa os bytes na criptografia MD5
    var digest = md5.convert(bytes);

    return digest;
  }

  Future<int> salvarDados(
      String nome, String sobrenome, String email, String senha) async {
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
      "sobrenome": sobrenome,
      "email": criptoEmail.toString(),
      "senha": criptoSenha.toString()
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
    dynamic criptoEmail = _criptografar(email);

    // Busca e exclusão de registro aprtir do email
    int retorno = await database!.delete("usuarios",
        where: "email = ?", //caracter curinga
        whereArgs: [criptoEmail.toString()]);
    print("Itens excluidos: " + retorno.toString());
  }

  dynamic atualizarUsuario(
      int id, String nome, String sobrenome, String email, String senha) async {
    dynamic emailCripto = _criptografar(email);
    dynamic senhaCripto = _criptografar(senha);

    Map<String, dynamic> dadosUsuario = {
      "nome": nome,
      "sobrenome": sobrenome,
      "email": emailCripto.toString(),
      "senha": senhaCripto.toString()
    };
    int retorno = await database!.update("usuarios", dadosUsuario,
        where: "id = ?", //caracter curinga
        whereArgs: [id]);
    print("Itens atualizados: " + retorno.toString());
  }

  /// Busca o usuario atraves do [email] e retorna uma lista com suas
  /// informações ou vazia, caso não encontre o registro
  Future<List> buscarUsuario(String email) async {
    dynamic criptoEmail = _criptografar(email);
    List usuarios = await database!.query("usuarios",
        columns: ["id", "nome", "sobrenome", "senha"],
        where: "email = ?",
        whereArgs: [criptoEmail.toString()]);

    print("oi: " + usuarios[0]["senha"]);

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
    }
    if (usuario[0]["senha"].toString().compareTo(senhaCripto.toString()) == 0) {
      return Future.value(true);
    }

    return Future.value(false);
  }
}
