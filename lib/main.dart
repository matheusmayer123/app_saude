import 'package:app_saude/providers/agenda_consulta_provider.dart';
import 'package:app_saude/providers/agenda_exame.dart';
import 'package:app_saude/providers/satisfacao_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_saude/myapp.dart';
import 'package:app_saude/dbconnection/mongodb.dart';
import 'package:app_saude/providers/user_provider.dart';
import 'package:app_saude/providers/medico_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDataBase.connect();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MedicoProvider()),
        ChangeNotifierProvider(create: (_) => AgendaConsultaProvider()),
        ChangeNotifierProvider(create: (_) => AgendaExameProvider()),
        ChangeNotifierProvider(create: (_) => SatisfacaoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
