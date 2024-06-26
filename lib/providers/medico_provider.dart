import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:collection/collection.dart';
import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/dbconnection/constant.dart';

class MedicoProvider with ChangeNotifier {
  mongo.Db? _db;
  mongo.DbCollection? _collection;
  List<MedicoMongoDbModel> _medicos = [];
  MedicoMongoDbModel? _loggedInMedico;

  List<MedicoMongoDbModel> get medicos => _medicos;

  MedicoMongoDbModel? get loggedInMedico => _loggedInMedico;

  MedicoProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _db = await mongo.Db.create(MONGO_URL);
    await _db!.open();

    while (_db!.state != mongo.State.OPEN) {
      await Future.delayed(Duration(milliseconds: 100));
    }

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
    if (_db == null || _db!.state != mongo.State.OPEN) {
      await _initialize();
    }
  }

  MedicoMongoDbModel? findMedicoByCPF(String cpf) {
    return medicos.firstWhereOrNull((m) => m.cpf == cpf);
  }

  Future<String> authenticateMedico(String cpf, String password) async {
    if (_medicos.isEmpty) {
      await _loadMedicos();
    }

    var medico = _medicos.firstWhereOrNull(
      (medico) => medico.cpf == cpf && medico.senha == password,
    );

    if (medico != null) {
      _loggedInMedico = medico; // Define o médico logado
      return 'Autenticação bem-sucedida';
    } else {
      return 'CPF ou senha incorretos';
    }
  }

  Future<void> updateMedico(
      String cpf, MedicoMongoDbModel updatedMedico) async {
    var index = _medicos.indexWhere((medico) => medico.cpf == cpf);
    if (index != -1) {
      await _collection!
          .update(mongo.where.eq('cpf', cpf), updatedMedico.toJson());
      await _loadMedicos();
      notifyListeners();
    }
  }

  void clearLoggedInMedico() {
    _loggedInMedico = null;
    notifyListeners();
  }
}
