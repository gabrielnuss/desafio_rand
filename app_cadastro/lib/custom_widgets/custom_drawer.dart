import 'package:app_cadastro/model/user_model.dart';
import 'package:app_cadastro/pages/login_page.dart';
import 'package:app_cadastro/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final User user;
  const CustomDrawer({super.key, required this.user});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late UserRepository userRepository;
  bool salvando = false;

  void deletarUsuario() async {
    userRepository = UserRepository();
    userRepository.delete(widget.user.getUsuario);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: salvando
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).secondaryHeaderColor,
            ))
          : Drawer(
              backgroundColor: Theme.of(context).primaryColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor),
                      accountEmail: Text(widget.user.getEmail),
                      accountName: Text(
                        "Olá, ${widget.user.getNome}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      currentAccountPicture: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.blueGrey.shade800,
                          child: const Icon(
                            Icons.person,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("Tem certeza?"),
                                content: const Text("Deseja realmente sair?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()));
                                      },
                                      child: const Text("Sim")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancelar")),
                                ],
                              );
                            });
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.red,
                          ),
                          Text(
                            "Sair",
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          salvando = false;
                        });
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("Atenção"),
                                content: const Text(
                                    'Ao clicar "sim" sua conta será deletada e o procedimento é irreversível. \nDeseja prosseguir?'),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          salvando = true;
                                        });
                                        deletarUsuario();
                                        setState(() {
                                          salvando = false;
                                        });
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()));
                                      },
                                      child: const Text("Sim")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancelar")),
                                ],
                              );
                            });
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          Text(
                            "Excluir Conta",
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
