import 'package:app_saude/pages/agenda_consulta.dart';
import 'package:app_saude/pages/home_page.dart';
import 'package:app_saude/pages/registerpage.dart';
import 'package:app_saude/dbconnection/user_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'App Saúde',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const AgendaConsultaPage(),
      ),
    );
  }
}
