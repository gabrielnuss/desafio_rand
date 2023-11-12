import 'package:app_cadastro/pages/login_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro',
      theme: ThemeData(
          primaryColor: Colors.blueGrey,
          secondaryHeaderColor: Colors.blueGrey.shade700),
      home: const LoginPage(),
    );
  }
}
