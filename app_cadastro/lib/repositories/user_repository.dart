import 'package:app_cadastro/model/user_model.dart';
import 'package:app_cadastro/repositories/database.dart';

class UserRepository {
  Future<User> selectUser(String user) async {
    var db = await DataBaseSQLite().getDataBase();
    var result =
        await db.rawQuery("SELECT * FROM users WHERE usuario = ?", [user]);
    if (result.isEmpty) {
      return User.empty();
    }
    var mapResult = result[0];
    return User(
        mapResult["usuario"].toString(),
        mapResult["senha"].toString(),
        mapResult["nome"].toString(),
        mapResult["email"].toString(),
        DateTime.parse(mapResult["nascimento"].toString()));
  }

  Future<void> insert(User user) async {
    var db = await DataBaseSQLite().getDataBase();
    db.rawInsert(
        "INSERT INTO users (usuario, senha, nome, email, nascimento) values(?,?,?,?,?)",
        [
          user.getUsuario,
          user.getSenha,
          user.getNome,
          user.getEmail,
          user.getNascimento.toString()
        ]);
  }

  Future<void> update(User user) async {
    var db = await DataBaseSQLite().getDataBase();
    db.rawInsert(
        "UPDATE users SET senha = ?, nome = ?, email = ?, nascimento = ? WHERE usuario = ?",
        [
          user.getSenha,
          user.getNome,
          user.getEmail,
          user.getNascimento.toString(),
          user.getUsuario,
        ]);
  }

  Future<void> delete(String usuario) async {
    var db = await DataBaseSQLite().getDataBase();
    db.rawInsert("DELETE from users WHERE usuario = ?", [usuario]);
  }
}
