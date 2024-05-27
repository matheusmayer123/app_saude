import 'package:app_saude/contact_list_page.dart';
import 'package:app_saude/dbconnection/mongodb.dart';

import 'package:app_saude/login_form.dart';
import 'package:app_saude/pages/home_page.dart';
import 'package:app_saude/pages/loadingpage.dart';
import 'package:app_saude/registerpage.dart';
import 'package:app_saude/user_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
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
        home: RegisterPage(),
      ),
    );
  }
}
