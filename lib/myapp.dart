import 'package:app_saude/lista_contatos.dart';
import 'package:app_saude/pages/loadingpage.dart';

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Saúde',
      theme: ThemeData(),
      home: ContactListPage(),
    );
  }
}
