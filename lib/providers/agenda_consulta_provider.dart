import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:app_saude/dbconnection/constant.dart';

class AgendaConsultaProvider with ChangeNotifier {
  Db? _db;
  DbCollection? _collection;

  AgendaConsultaProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _db = await Db.create(MONGO_URL);
    await _db!.open();
    _collection = _db!.collection(COLLECTION_SCHEDULE);
    notifyListeners();
  }

  Future<void> _ensureInitialized() async {
    if (_db == null || _collection == null) {
      await _initialize();
    }

    // Verifique o estado da conexão
    await _db!.open();
  }

  Future<void> saveAgendaConsultaToDatabase(
      Map<String, dynamic> agendaConsulta) async {
    await _ensureInitialized();
    await _collection!.insert(agendaConsulta);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getAllAgendaConsultas() async {
    await _ensureInitialized();
    var agendaConsultas = await _collection!.find().toList();
    return agendaConsultas.map((json) => json as Map<String, dynamic>).toList();
  }
}
