import 'package:app_saude/myapp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_saude/dbconnection/mongodb.dart';
import 'contact_list_page.dart'; // Vamos criar este novo arquivo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDataBase.connect();
  runApp(MyApp());
}
