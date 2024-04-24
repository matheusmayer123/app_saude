import 'package:app_saude/dbconnection/mongodb.dart';
import 'package:app_saude/myapp.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDataBase.connect();
  runApp(const MyApp());
}
