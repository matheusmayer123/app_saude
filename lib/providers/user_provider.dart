import 'package:flutter/material.dart';
import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/dbconnection/mongodb.dart';
import 'package:app_saude/pages/home_page_intern.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }
}

class UserProvider extends ChangeNotifier {
  List<MongoDbModel> _users = [];
  MongoDbModel? _loggedInUser;
  String? _cpfDigitado;

  MongoDbModel? get loggedInUser => _loggedInUser;
  List<MongoDbModel> get users => _users;

  Future<void> loadUsersFromDatabase() async {
    var userList = await MongoDataBase.getUser();
    _users = userList.map((user) => MongoDbModel.fromJson(user)).toList();
    notifyListeners();
  }

  Future<void> saveUserToDatabase(MongoDbModel user) async {
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

  Future<void> updateUser(ObjectId id, MongoDbModel updatedUser) async {
    var index = _users.indexWhere((user) => user.id == id);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners();
      await MongoDataBase.updateUser(
          id, updatedUser.toJson()); // Atualiza no banco de dados
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
      (user) => user.cpf == cpf && user.senha == password,
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

    if (cpf == '123' && password == '123') {
      _loggedInUser = user; // Definir o usuário logado
      await NavigationService.navigateTo('/homePageIntern');
      return 'Redirecionando para a página de admin';
    } else if (user.cpf.isNotEmpty && user.senha == password) {
      _loggedInUser = user; // Definir o usuário logado
      return 'Autenticação bem-sucedida';
    } else {
      return 'CPF ou senha incorretos';
    }
  }
}
