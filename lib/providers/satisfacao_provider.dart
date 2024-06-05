import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:app_saude/dbconnection/constant.dart';

class SatisfacaoProvider with ChangeNotifier {
  Db? _db;
  DbCollection? _collection;

  SatisfacaoProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _db = await Db.create(MONGO_URL);
    await _db!.open();
    _collection = _db!.collection(COLLECTION_CSAT);
    notifyListeners();
  }

  Future<void> _ensureInitialized() async {
    if (_db == null || _collection == null) {
      await _initialize();
    }
  }

  Future<void> saveSatisfacaoToDatabase(Map<String, dynamic> satisfacao) async {
    await _ensureInitialized();
    await _collection!.insert(satisfacao);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getAllSatisfacoes() async {
    await _ensureInitialized();
    var satisfacoes = await _collection!.find().toList();
    return satisfacoes.map((json) => json as Map<String, dynamic>).toList();
  }
}
