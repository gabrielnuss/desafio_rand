import 'package:app_cadastro/model/user_model.dart';
import 'package:app_cadastro/pages/cadasto_page.dart';
import 'package:app_cadastro/pages/esqueci_senha_page.dart';
import 'package:app_cadastro/pages/home_page.dart';
import 'package:flutter/material.dart';

void abrirHomePage(BuildContext context, User userHomePage) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
                user: userHomePage,
              )));
}

void abrirCadastroPage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const CadastroPage()));
}

void abrirEsqueciSenhaPage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => EsqueciSenhaPage()));
}

void showCustomDialog(BuildContext context, List<String> camposInvalidos) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Atenção",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                "Preencha os seguintes campos:",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: camposInvalidos.length,
              itemBuilder: (BuildContext bc, int index) {
                var campo = camposInvalidos[index];
                return Text(campo);
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        );
      });
}

void showCustomSnackBar(BuildContext context, String texto) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
}
