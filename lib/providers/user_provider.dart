import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/dbconnection/mongodb.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UserProvider extends ChangeNotifier {
  List<MongoDbModel> _users = [];
  String? _cpfDigitado;

  List<MongoDbModel> get users => _users;

  Future<void> loadUsersFromDatabase() async {
    var userList = await MongoDataBase.getUser();
    _users = userList.map((user) => MongoDbModel.fromJson(user)).toList();
    notifyListeners();
  }

  Future<void> saveUserToDatabase(MongoDbModel user) async {
    // Verificar se o CPF já existe na lista de usuários
    if (_users.any((existingUser) => existingUser.cpf == user.cpf)) {
      throw Exception('CPF já cadastrado');
    }

    await MongoDataBase.insertUser(user);
    _users.add(user);
    notifyListeners();
  }

  void addUser(MongoDbModel user) {
    _users.add(user);
    notifyListeners();
  }

  void updateUser(ObjectId id, MongoDbModel updatedUser) {
    var index = _users.indexWhere((user) => user.id == id);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners();
    }
  }

  void deleteUser(ObjectId id) {
    _users.removeWhere((user) => user.id == id);
    notifyListeners();
  }

  Future<String> authenticateUser(String cpf, String password) async {
    if (_users.isEmpty) {
      await loadUsersFromDatabase();
    }

    _cpfDigitado = cpf;

    var user = _users.firstWhere(
      (user) => user.cpf == cpf,
      orElse: () => MongoDbModel(
        id: ObjectId(),
        nome: '',
        sobrenome: '',
        email: '',
        cpf: '',
        rua: '',
        numeroCasa: '',
        bairro: '',
        senha: '',
      ),
    );

    print('CPF digitado: $_cpfDigitado');
    print('CPF do usuário no banco de dados: ${user.cpf}');
    print('Senha digitada: $password');
    print('Senha do usuário no banco de dados: ${user.senha}');

    if (user.cpf.isNotEmpty && user.senha == password) {
      return 'Autenticação bem-sucedida';
    } else {
      return 'CPF ou senha incorretos';
    }
  }
}
