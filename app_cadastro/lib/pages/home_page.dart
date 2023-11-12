import 'package:app_cadastro/custom_widgets/custom_drawer.dart';
import 'package:app_cadastro/custom_widgets/title_text.dart';
import 'package:app_cadastro/model/user_model.dart';
import 'package:app_cadastro/repositories/user_repository.dart';
import 'package:app_cadastro/util/functions.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var nomeController = TextEditingController(text: "");
  var emailController = TextEditingController(text: "");
  var emailFocusNode = FocusNode();
  var nascimentoController = TextEditingController(text: "");
  var nascimentoFocusNode = FocusNode();
  List<String> camposInvalidos = [];
  late DateTime? nascimento;
  late UserRepository userRepository;
  bool salvando = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preencherCampos();
  }

  void atualizarCadastro() async {
    userRepository = UserRepository();
    widget.user.setNome(nomeController.text);
    widget.user.setEmail(emailController.text);
    widget.user.setNascimento(nascimento!);
    userRepository.update(widget.user);
    showCustomSnackBar(context, "Cadastro atualizado com sucesso!");
  }

  void preencherCampos() {
    nomeController.text = widget.user.getNome;
    emailController.text = widget.user.getEmail;
    nascimentoController.text =
        "${widget.user.getNascimento.day}/${widget.user.getNascimento.month}/${widget.user.getNascimento.year}";
    nascimento = widget.user.getNascimento;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const TitleText(
          text: "Dados do cadastro",
        ),
        elevation: 10,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: salvando
            ? Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).secondaryHeaderColor,
              ))
            : ListView(children: [
                const TitleText(text: "Nome:"),
                TextField(
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
                  height: 15,
                ),
                const TitleText(text: "E-mail:"),
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
                      FocusScope.of(context).requestFocus(nascimentoFocusNode);
                    }),
                const SizedBox(
                  height: 15,
                ),
                const TitleText(text: "Data de nascimento:"),
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
                      camposInvalidos.clear();
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
                        atualizarCadastro();
                        setState(() {
                          salvando = false;
                        });
                      } else {
                        showCustomDialog(context, camposInvalidos);
                      }
                    },
                    child: const Text(
                      "Atualizar cadastro",
                      style: TextStyle(color: Colors.white),
                    )),
              ]),
      ),
      drawer: CustomDrawer(
        user: widget.user,
      ),
    );
  }
}
