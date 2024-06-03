
import 'package:app_saude/registerpage.dart';
import 'package:app_saude/user_provider.dart';

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
        home: const RegisterPage(),
      ),
    );
  }
}
