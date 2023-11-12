import 'package:app_cadastro/model/user_model.dart';
import 'package:app_cadastro/pages/login_page.dart';
import 'package:app_cadastro/repositories/user_repository.dart';
import 'package:app_cadastro/util/functions.dart';
import 'package:flutter/material.dart';

class EsqueciSenhaPage extends StatefulWidget {
  const EsqueciSenhaPage({super.key});

  @override
  State<EsqueciSenhaPage> createState() => _EsqueciSenhaPageState();
}

class _EsqueciSenhaPageState extends State<EsqueciSenhaPage> {
  var usuarioController = TextEditingController(text: "");
  var senhaController = TextEditingController(text: "");
  var confirmarSenhaController = TextEditingController(text: "");
  var senhaFocusNode = FocusNode();
  var confirmarSenhaFocusNode = FocusNode();
  late UserRepository userRepository;
  late User user;
  bool salvando = false;

  void atualizarSenha() async {
    userRepository = UserRepository();
    user = await userRepository.selectUser(usuarioController.text);
    if (user.getUsuario.isEmpty) {
      showCustomSnackBar(context, "Usuário inexistente");
    } else {
      if (confirmarSenhaController.text != senhaController.text) {
        showCustomSnackBar(context, "Senhas não são iguais");
      } else {
        user.setSenha(senhaController.text);
        userRepository.update(user);
        showCustomSnackBar(context, "Senha atualizada com sucesso!");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Alterar senha"),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: salvando
            ? Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).secondaryHeaderColor,
              ))
            : ListView(
                children: [
                  TextField(
                      controller: usuarioController,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        contentPadding: EdgeInsets.only(top: 15),
                        hintText: "Usuário",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(senhaFocusNode);
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                      obscureText: true,
                      focusNode: senhaFocusNode,
                      controller: senhaController,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        contentPadding: EdgeInsets.only(top: 15),
                        hintText: "Nova senha",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      onEditingComplete: () {
                        FocusScope.of(context)
                            .requestFocus(confirmarSenhaFocusNode);
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: true,
                    focusNode: confirmarSenhaFocusNode,
                    controller: confirmarSenhaController,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      contentPadding: EdgeInsets.only(top: 15),
                      hintText: "Confirmar senha",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor),
                      onPressed: () async {
                        setState(() {
                          salvando = false;
                        });
                        if (usuarioController.text.isEmpty) {
                          showCustomSnackBar(context,
                              "Preencha corretamente o campo de usuário");
                          return;
                        }
                        if (senhaController.text.isEmpty) {
                          showCustomSnackBar(context,
                              "Preencha corretamente o campo de senha");
                          return;
                        }
                        if (confirmarSenhaController.text.isEmpty) {
                          showCustomSnackBar(context,
                              "Preencha corretamente o campo de confirmar senha");
                          return;
                        }
                        setState(() {
                          salvando = true;
                        });
                        atualizarSenha();
                        setState(() {
                          salvando = false;
                        });
                      },
                      child: const Text(
                        "Alterar senha",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
      ),
    ));
  }
}
