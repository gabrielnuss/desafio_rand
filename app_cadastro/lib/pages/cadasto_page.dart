// ignore_for_file: use_build_context_synchronously

import 'package:app_cadastro/model/user_model.dart';
import 'package:app_cadastro/repositories/user_repository.dart';
import 'package:app_cadastro/util/functions.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  var usuarioController = TextEditingController(text: "");
  var senhaController = TextEditingController(text: "");
  var senhaFocusNode = FocusNode();
  var nomeController = TextEditingController(text: "");
  var nomeFocusNode = FocusNode();
  var emailController = TextEditingController(text: "");
  var emailFocusNode = FocusNode();
  var nascimentoController = TextEditingController(text: "");
  var nascimentoFocusNode = FocusNode();
  late UserRepository userRepository;
  late User user;
  List<String> camposInvalidos = [];
  bool textoOculto = true;
  bool salvando = false;
  late DateTime? nascimento;

  void salvarDados() async {
    userRepository = UserRepository();
    user = await userRepository.selectUser(usuarioController.text);
    if (user.getUsuario.isEmpty) {
      user = User(usuarioController.text, senhaController.text,
          nomeController.text, emailController.text, nascimento!);
      userRepository.insert(user);
      abrirHomePage(context, user);
      showCustomSnackBar(context, "Cadastro realizado com sucesso");
    } else {
      showCustomSnackBar(context, "Usuário já cadastrado.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: const Text("Cadastro"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                        obscureText: textoOculto,
                        focusNode: senhaFocusNode,
                        controller: senhaController,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          contentPadding: const EdgeInsets.only(top: 15),
                          hintText: "Senha",
                          hintStyle: const TextStyle(color: Colors.white),
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
                              )),
                        ),
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(nomeFocusNode);
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                        focusNode: nomeFocusNode,
                        controller: nomeController,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          contentPadding: EdgeInsets.only(top: 15),
                          hintText: "Nome",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(emailFocusNode);
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                        focusNode: emailFocusNode,
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          contentPadding: EdgeInsets.only(top: 15),
                          hintText: "E-mail",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        onEditingComplete: () {
                          FocusScope.of(context)
                              .requestFocus(nascimentoFocusNode);
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      focusNode: nascimentoFocusNode,
                      controller: nascimentoController,
                      readOnly: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        contentPadding: EdgeInsets.only(top: 15),
                        hintText: "Data de nascimento",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        nascimento = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900, 1, 1),
                            lastDate: DateTime.now());
                        setState(() {
                          if (nascimento != null) {
                            nascimentoController.text =
                                "${nascimento!.day}/${nascimento!.month}/${nascimento!.year}";
                          } else {
                            nascimentoController.text = "";
                          }
                        });
                      },
                    ),
                    const SizedBox(
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
                          camposInvalidos.clear();
                          if (usuarioController.text.isEmpty) {
                            camposInvalidos.add("Usuário");
                          }
                          if (senhaController.text.isEmpty) {
                            camposInvalidos.add("Senha");
                          }
                          if (nomeController.text.isEmpty) {
                            camposInvalidos.add("Nome");
                          }
                          if (emailController.text.isEmpty) {
                            camposInvalidos.add("E-mail");
                          }
                          if (nascimentoController.text.isEmpty) {
                            camposInvalidos.add("Data de nascimento");
                          }

                          if (camposInvalidos.isEmpty) {
                            setState(() {
                              salvando = true;
                            });

                            salvarDados();
                            setState(() {
                              salvando = false;
                            });
                          } else {
                            showCustomDialog(context, camposInvalidos);
                          }
                        },
                        child: const Text(
                          "Entrar",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
        ),
      ),
    );
  }
}
