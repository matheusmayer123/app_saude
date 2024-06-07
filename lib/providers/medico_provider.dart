import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:collection/collection.dart'; // Importe a biblioteca collection
import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/dbconnection/constant.dart';

class MedicoProvider with ChangeNotifier {
  mongo.Db? _db; // Usando o alias 'mongo' para evitar conflito de nomes
  mongo.DbCollection?
      _collection; // Usando o alias 'mongo' para evitar conflito de nomes
  List<MedicoMongoDbModel> _medicos = [];

  List<MedicoMongoDbModel> get medicos => _medicos;

  MedicoProvider() {
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

    _collection = _db!.collection(COLLECTION_DOCTORS); // Usando o alias 'mongo'
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
    if (_db == null || _db!.state != mongo.State.OPEN) {
      await _initialize();
    }
  }

  MedicoMongoDbModel? findMedicoByCPF(String cpf) {
    return medicos.firstWhereOrNull((m) => m.cpf == cpf);
  }
}
