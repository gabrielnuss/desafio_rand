import 'dart:io';

import 'package:app_cadastro/custom_widgets/title_text.dart';
import 'package:app_cadastro/model/user_model.dart';
import 'package:app_cadastro/repositories/user_repository.dart';
import 'package:app_cadastro/util/functions.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var usuarioController = TextEditingController(text: "");
  var senhaController = TextEditingController(text: "");
  final senhaFocusNode = FocusNode();
  late UserRepository userRepository;
  late User user;
  bool textoOculto = true;
  bool salvando = false;

  void usuarioSenhaInvalido() {
    showCustomSnackBar(context, "Usuário ou senha inválidos");
  }

  void validarLoginSenha() async {
    userRepository = UserRepository();
    user = await userRepository.selectUser(usuarioController.text);
    if (user.getUsuario.isEmpty) {
      usuarioSenhaInvalido();
    } else {
      if (user.getSenha != senhaController.text) {
        usuarioSenhaInvalido();
      } else {
        abrirHomePage(context, user);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: salvando
              ? Center(
                  child: CircularProgressIndicator(
                  color: Theme.of(context).secondaryHeaderColor,
                ))
              : ListView(
                  children: [
                    Expanded(child: Container()),
                    Image.asset("lib/assets/images/logo.png"),
                    const SizedBox(
                      height: 100,
                    ),
                    Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const TitleText(text: "Bem vindo!")),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const TitleText(text: "Já possui cadastro?")),
                    const SizedBox(
                      height: 20,
                    ),
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
                            prefixIcon: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                            )),
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(senhaFocusNode);
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      obscureText: textoOculto,
                      focusNode: senhaFocusNode,
                      controller: senhaController,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          contentPadding: const EdgeInsets.only(top: 15),
                          hintText: "Senha",
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                textoOculto = !textoOculto;
                              });
                            },
                            child: Icon(
                              textoOculto
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                          )),
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
                          setState(() {
                            salvando = true;
                          });
                          validarLoginSenha();
                          setState(() {
                            salvando = false;
                          });
                        },
                        child: const Text(
                          "Entrar",
                          style: TextStyle(color: Colors.white),
                        )),
                    Expanded(child: Container()),
                    TextButton(
                        onPressed: () {
                          abrirEsqueciSenhaPage(context);
                        },
                        child: const Text(
                          "Esqueci minha senha",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white),
                        )),
                    TextButton(
                        onPressed: () {
                          abrirCadastroPage(context);
                        },
                        child: const Text(
                          "Cadastrar-se",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white),
                        )),
                  ],
                ),
        ),
      ),
    );
  }
}
