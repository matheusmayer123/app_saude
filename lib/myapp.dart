import 'package:app_saude/pages/avaliacoes_page.dart';
import 'package:app_saude/pages/home_page_intern.dart';
import 'package:app_saude/pages/loginpage.dart';

import 'package:app_saude/providers/user_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        navigatorKey: NavigationService.navigatorKey,
        routes: {
          '/homePageIntern': (context) => HomePageIntern(),
        },
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        title: 'App Saúde',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: LoginPage(),
        debugShowCheckedModeBanner:
            false, // Adiciona esta linha para remover a etiqueta de depuração
      ),
    );
  }
}
