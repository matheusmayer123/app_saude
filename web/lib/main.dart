import 'package:app_saude/myapp.dart';
import 'package:flutter/material.dart';

import 'package:app_saude/dbconnection/mongodb.dart';
// Vamos criar este novo arquivo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDataBase.connect();
  runApp(const MyApp());
}
