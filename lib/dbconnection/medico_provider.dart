import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/dbconnection/constant.dart';

class MedicoProvider with ChangeNotifier {
  Db? _db;
  DbCollection? _collection;

  MedicoProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _db = await Db.create(MONGO_URL);
    await _db!.open();
    _collection = _db!.collection(COLLECTION_DOCTORS);
    notifyListeners();
  }

  Future<void> saveMedicoToDatabase(MedicoMongoDbModel medico) async {
    await _ensureInitialized();
    await _collection!.insert(medico.toJson());
    notifyListeners();
  }

  Future<List<MedicoMongoDbModel>> getAllMedicos() async {
    await _ensureInitialized();
    var medicos = await _collection!.find().toList();
    return medicos.map((json) => MedicoMongoDbModel.fromJson(json)).toList();
  }

  Future<void> _ensureInitialized() async {
    if (_db == null || _collection == null) {
      await _initialize();
    }
  }
}
