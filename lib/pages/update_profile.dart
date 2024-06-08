import 'package:flutter/material.dart';
import 'package:app_saude/providers/user_provider.dart';
import 'package:app_saude/providers/medico_provider.dart';
import 'package:provider/provider.dart';
import 'package:app_saude/dbconnection/MongoDbModel.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _sobrenomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _ruaController = TextEditingController();
  TextEditingController _numeroCasaController = TextEditingController();
  TextEditingController _bairroController = TextEditingController();
  TextEditingController _especialidadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Adicione um listener para atualizar os campos de formulário quando o estado da página for alterado
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final medicoProvider =
          Provider.of<MedicoProvider>(context, listen: false);
      final loggedInUser = userProvider.loggedInUser;
      final loggedInMedico = medicoProvider.loggedInMedico;

      if (loggedInUser != null) {
        _nomeController.text = loggedInUser.nome;
        _sobrenomeController.text = loggedInUser.sobrenome;
        _emailController.text = loggedInUser.email;
        _ruaController.text = loggedInUser.rua;
        _numeroCasaController.text = loggedInUser.numeroCasa;
        _bairroController.text = loggedInUser.bairro;
      } else if (loggedInMedico != null) {
        _nomeController.text = loggedInMedico.nome;
        _sobrenomeController.text = loggedInMedico.sobrenome;
        _emailController.text = loggedInMedico.email;
        _ruaController.text = loggedInMedico.rua;
        _numeroCasaController.text = loggedInMedico.numeroCasa;
        _bairroController.text = loggedInMedico.bairro;
        _especialidadeController.text = loggedInMedico.especialidade;
      }
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _emailController.dispose();
    _ruaController.dispose();
    _numeroCasaController.dispose();
    _bairroController.dispose();
    _especialidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final medicoProvider = Provider.of<MedicoProvider>(context);
    final loggedInUser = userProvider.loggedInUser;
    final loggedInMedico = medicoProvider.loggedInMedico;

    return Scaffold(
      appBar: AppBar(
        title: Text('Atualizar Perfil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sobrenomeController,
                decoration: InputDecoration(labelText: 'Sobrenome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o sobrenome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ruaController,
                decoration: InputDecoration(labelText: 'Rua'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite a rua';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _numeroCasaController,
                decoration: InputDecoration(labelText: 'Número da Casa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o número da casa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bairroController,
                decoration: InputDecoration(labelText: 'Bairro'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o bairro';
                  }
                  return null;
                },
              ),
              if (loggedInMedico != null)
                TextFormField(
                  controller: _especialidadeController,
                  decoration: InputDecoration(labelText: 'Especialidade'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite a especialidade';
                    }
                    return null;
                  },
                ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Lógica para atualizar o perfil
                    if (loggedInUser != null) {
                      userProvider.updateUser(
                        loggedInUser.id,
                        MongoDbModel(
                          id: loggedInUser.id,
                          nome: _nomeController.text,
                          sobrenome: _sobrenomeController.text,
                          email: _emailController.text,
                          cpf: loggedInUser.cpf,
                          rua: _ruaController.text,
                          numeroCasa: _numeroCasaController.text,
                          bairro: _bairroController.text,
                          senha: loggedInUser.senha,
                        ),
                      );
                    } else if (loggedInMedico != null) {
                      medicoProvider.updateMedico(
                        loggedInMedico.cpf,
                        MedicoMongoDbModel(
                          id: loggedInMedico.id,
                          nome: _nomeController.text,
                          sobrenome: _sobrenomeController.text,
                          email: _emailController.text,
                          cpf: loggedInMedico.cpf,
                          rua: _ruaController.text,
                          numeroCasa: _numeroCasaController.text,
                          bairro: _bairroController.text,
                          senha: loggedInMedico.senha,
                          crm: loggedInMedico.crm,
                          especialidade: _especialidadeController.text,
                        ),
                      );
                    }
                    // Navegar de volta após a atualização
                    Navigator.pop(context);
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
