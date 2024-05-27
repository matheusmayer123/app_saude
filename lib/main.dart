import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_saude/myapp.dart';
import 'package:app_saude/dbconnection/mongodb.dart';
import 'package:app_saude/dbconnection/user_provider.dart';
import 'package:app_saude/dbconnection/medico_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDataBase.connect();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MedicoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
