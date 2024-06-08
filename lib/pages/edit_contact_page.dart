import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/dbconnection/mongodb.dart';
import 'package:flutter/material.dart';

class EditUserPage extends StatefulWidget {
  final MongoDbModel user;

  const EditUserPage({super.key, required this.user});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late String _nome;
  late String _sobrenome;
  late String _email;
  late String _cpf;
  late String _rua;
  late String _numeroCasa;
  late String _bairro;
  late String _senha;

  @override
  void initState() {
    super.initState();
    _nome = widget.user.nome;
    _sobrenome = widget.user.sobrenome;
    _email = widget.user.email;
    _cpf = widget.user.cpf;
    _rua = widget.user.rua;
    _numeroCasa = widget.user.numeroCasa;
    _bairro = widget.user.bairro;
    _senha = widget.user.senha;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _nome,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
                onSaved: (value) => _nome = value!,
              ),
              
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    MongoDataBase.updateUser(
                      widget.user.id,
                      MongoDbModel(
                        id: widget.user.id,
                        nome: _nome,
                        sobrenome: _sobrenome,
                        email: _email,
                        cpf: _cpf,
                        rua: _rua,
                        numeroCasa: _numeroCasa,
                        bairro: _bairro,
                        senha: _senha,
                      ) as Map<String, dynamic>,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
