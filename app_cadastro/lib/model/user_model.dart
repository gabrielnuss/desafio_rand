class User {
  String _usuario = "";
  String _senha = "";
  String _nome = "";
  String _email = "";
  DateTime _nascimento = DateTime.now();

  User(this._usuario, this._senha, this._nome, this._email, this._nascimento);

  User.empty();

  String get getUsuario => _usuario;
  String get getSenha => _senha;
  String get getNome => _nome;
  String get getEmail => _email;
  DateTime get getNascimento => _nascimento;

  void setUsuario(String usuario) {
    _usuario = usuario;
  }

  void setSenha(String senha) {
    _senha = senha;
  }

  void setNome(String nome) {
    _nome = nome;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setNascimento(DateTime nascimento) {
    _nascimento = nascimento;
  }
}
