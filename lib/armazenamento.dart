import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Armazenamento {
  late Database bd;
  late String caminhoBancoDados;
  late String localBancoDados;

  Armazenamento() {
    _initBD();
  }

  void _initBD() async {
    bd = await _recuperarBancoDados();
    caminhoBancoDados = await getDatabasesPath();
    localBancoDados = join(caminhoBancoDados, "banco3.bd");
  }

  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco3.bd");
    var bd = await openDatabase(localBancoDados, version: 1,
        onCreate: (db, dbVersaoRecente) {
      String sql =
          "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER) ";
      db.execute(sql);
    });
    return bd;
    //print("aberto: " + bd.isOpen.toString() );
  }

  _salvarDados(String nome, int idade) async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {"nome": nome, "idade": idade};
    int id = await bd.insert("usuarios", dadosUsuario);
    print("Salvo: $id ");
  }

  _listarUsuarios() async {
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM usuarios";
    //String sql = "SELECT * FROM usuarios WHERE idade=58";
    //String sql = "SELECT * FROM usuarios WHERE idade >=30 AND idade <=58";
    //String sql = "SELECT * FROM usuarios WHERE idade BETWEEN 18 AND 58";
    //String sql = "SELECT * FROM usuarios WHERE nome='Maria Silva'";
    List usuarios =
        await bd.rawQuery(sql); //conseguimos escrever a query que quisermos
    for (var usu in usuarios) {
      print(" id: " +
          usu['id'].toString() +
          " nome: " +
          usu['nome'] +
          " idade: " +
          usu['idade'].toString());
    }
  }

  _listarUmUsuario(int id) async {
    Database bd = await _recuperarBancoDados();
    List usuarios = await bd.query("usuarios",
        columns: ["id", "nome", "idade"], where: "id = ?", whereArgs: [id]);
    for (var usu in usuarios) {
      print(" id: " +
          usu['id'].toString() +
          " nome: " +
          usu['nome'] +
          " idade: " +
          usu['idade'].toString());
    }
  }

  /*_excluirUsuario(int id) async{
    Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "usuarios",
        where: "id = ?",  //caracter curinga
        whereArgs: [id]
    );
    print("Itens excluidos: "+retorno.toString());
  }*/

  _excluirUsuario(int id) async {
    Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete("usuarios",
        // where: "nome = ? AND idade = ?",  //caracter curinga
        // whereArgs: ["Raquel Ribeiro", 26]
        where: "id = ?", //caracter curinga
        whereArgs: [id]);
    print("Itens excluidos: " + retorno.toString());
  }

  _atualizarUsuario(int id) async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome": "Antonio Pedro",
      "idade": 35,
    };
    int retorno = await bd.update("usuarios", dadosUsuario,
        where: "id = ?", //caracter curinga
        whereArgs: [id]);
    print("Itens atualizados: " + retorno.toString());
  }
}
