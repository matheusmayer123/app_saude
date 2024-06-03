import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/dbconnection/mongodb.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UserProvider extends ChangeNotifier {
  List<MongoDbModel> _users = [];
  String? _cpfDigitado; // Adicionando a propriedade cpfDigitado

  List<MongoDbModel> get users => _users;

  Future<void> loadUsersFromDatabase() async {
    var userList = await MongoDataBase.getUser();
    _users = userList.map((user) => MongoDbModel.fromJson(user)).toList();
    notifyListeners();
  }

  Future<void> saveUserToDatabase(MongoDbModel user) async {
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
    // Verificar se a lista de usuários está vazia e carregar do banco de dados se necessário
    if (_users.isEmpty) {
      await loadUsersFromDatabase();
    }

    // Armazenar o CPF digitado
    _cpfDigitado = cpf;

    // Consultar o banco de dados para buscar o usuário com o CPF fornecido
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
        senha: '', // Valores padrão para o usuário
      ),
    );

    print('CPF digitado: $_cpfDigitado');
    print('CPF do usuário no banco de dados: ${user.cpf}');
    print('Senha digitada: $password');
    print('Senha do usuário no banco de dados: ${user.senha}');

    if (user.cpf.isNotEmpty && user.senha == password) {
      return 'Autenticação bem-sucedida'; // Autenticação bem-sucedida
    } else {
      return 'CPF ou senha incorretos'; // Autenticação falhou
    }
  }
}
