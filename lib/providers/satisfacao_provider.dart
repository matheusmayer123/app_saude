import 'package:app_saude/dbconnection/constant.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo; // Usando o alias 'mongo'

class SatisfacaoProvider with ChangeNotifier {
  mongo.Db? _db; // Usando o alias 'mongo' para evitar conflito de nomes
  mongo.DbCollection?
      _collection; // Usando o alias 'mongo' para evitar conflito de nomes
  List<Map<String, dynamic>> _satisfacoes = [];

  List<Map<String, dynamic>> get satisfacoes => _satisfacoes;

  SatisfacaoProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _db = await mongo.Db.create(MONGO_URL); // Usando o alias 'mongo'
    await _db!.open();

    // Adiciona um loop para aguardar até que o banco de dados esteja no estado 'State.OPEN'
    while (_db!.state != mongo.State.OPEN) {
      await Future.delayed(Duration(
          milliseconds:
              100)); // Aguarda 100 milissegundos antes de verificar novamente
    }

    _collection = _db!.collection(COLLECTION_CSAT); // Usando o alias 'mongo'
    await _loadSatisfacoes();
    notifyListeners();
  }

  Future<void> _ensureInitialized() async {
    if (_db == null || _collection == null) {
      await _initialize();
    }
  }

  Future<void> _loadSatisfacoes() async {
    await _ensureInitialized();
    var satisfacoes = await _collection!.find().toList();
    _satisfacoes =
        satisfacoes.map((json) => json as Map<String, dynamic>).toList();
  }

  Future<void> saveSatisfacaoToDatabase(Map<String, dynamic> satisfacao) async {
    await _ensureInitialized();
    await _collection!.insert(satisfacao);
    await _loadSatisfacoes();
    notifyListeners();
  }
}
