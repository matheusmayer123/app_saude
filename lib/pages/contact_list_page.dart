import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:flutter/material.dart';

class ViewUserPage extends StatelessWidget {
  final MongoDbModel? user;

  const ViewUserPage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${user?.nome}'),
            Text('Sobrenome: ${user?.sobrenome}'),
            Text('Email: ${user?.email}'),
            Text('CPF: ${user?.cpf}'),
            Text('Rua: ${user?.rua}'),
            Text('Número da Casa: ${user?.numeroCasa}'),
            Text('Bairro: ${user?.bairro}'),
          ],
        ),
      ),
    );
  }
}
