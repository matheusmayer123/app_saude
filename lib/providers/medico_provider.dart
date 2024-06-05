import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:collection/collection.dart'; // Importe a biblioteca collection
import 'package:collection/collection.dart';

import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/dbconnection/constant.dart';

class MedicoProvider with ChangeNotifier {
  Db? _db;
  DbCollection? _collection;
  List<MedicoMongoDbModel> _medicos = []; // Lista de médicos

  List<MedicoMongoDbModel> get medicos => _medicos;

  MedicoProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _db = await Db.create(MONGO_URL);
    await _db!.open();
    _collection = _db!.collection(COLLECTION_DOCTORS);
    await _loadMedicos();
    notifyListeners();
  }

  Future<List<MedicoMongoDbModel>> getAllMedicos() async {
    await _ensureInitialized();
    var medicos = await _collection!.find().toList();
    return medicos.map((json) => MedicoMongoDbModel.fromJson(json)).toList();
  }

  Future<void> saveMedicoToDatabase(MedicoMongoDbModel medico) async {
    await _ensureInitialized();
    await _collection!.insert(medico.toJson());
    await _loadMedicos();
    notifyListeners();
  }

  Future<void> _loadMedicos() async {
    if (_collection != null) {
      var medicosData = await _collection!.find().toList();
      _medicos =
          medicosData.map((json) => MedicoMongoDbModel.fromJson(json)).toList();
    }
  }

  Future<void> _ensureInitialized() async {
    if (_db == null || _collection == null) {
      await _initialize();
    }
  }

  MedicoMongoDbModel? findMedicoByCPF(String cpf) {
    return medicos.firstWhereOrNull((m) =>
        m.cpf == cpf); // Utilize o método firstWhereOrNull na lista medicos
  }
}
