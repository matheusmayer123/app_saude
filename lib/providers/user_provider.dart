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
        imageUrl: '', // Adicionando o campo imageUrl
      ),
    );

    print('CPF digitado: $_cpfDigitado');
    print('CPF do usuário no banco de dados: ${user.cpf}');
    print('Senha digitada: $password');
    print('Senha do usuário no banco de dados: ${user.senha}');
    if (cpf == '123' && password == '123') {
      await NavigationService.navigateTo('/homePageIntern');
      return 'Redirecionando para a página de admin';
    } else {
      // Se a autenticação for bem-sucedida com um usuário normal, faça outra coisa, como exibir uma mensagem ou atualizar o estado do widget.
      return 'Autenticação bem-sucedida';
    }
  }

  Future<void> updateUserImageUrl(String imageUrl) async {
    // Atualizar o usuário com o novo link de imagem
    var index = _users.indexWhere((user) => user.cpf == _cpfDigitado);
    if (index != -1) {
      _users[index] = _users[index].copyWith(imageUrl: imageUrl);
      notifyListeners();

      // Salvar o usuário atualizado no SharedPreferences
      await _saveUserToSharedPreferences(_users[index]);
    }
  }

  Future<void> _saveUserToSharedPreferences(MongoDbModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_image_link', user.imageUrl ?? '');
  }
}
