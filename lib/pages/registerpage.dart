import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart'; // Importe este pacote para usar firstWhereOrNull
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/pages/created_account.dart';
import 'package:app_saude/providers/user_provider.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../field_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerSobrenome = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  var controllerCPF = MaskedTextController(mask: '000.000.000-00');
  TextEditingController controllerRua = TextEditingController();
  TextEditingController controllerNumeroCasa = TextEditingController();
  TextEditingController controllerBairro = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    // Regex para validar o formato do email
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return 'Formato de email inválido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro de Paciente',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(62, 124, 120, 1.0),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  FieldForm(
                    label: 'Nome',
                    isPassword: false,
                    controller: controllerNome,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nome é obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  FieldForm(
                    label: 'Sobrenome',
                    isPassword: false,
                    controller: controllerSobrenome,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Sobrenome é obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  FieldForm(
                    label: 'Email',
                    isPassword: false,
                    controller: controllerEmail,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 10),
                  FieldForm(
                    label: 'CPF',
                    isPassword: false,
                    controller: controllerCPF,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CPF é obrigatório';
                      }
                      if (value.length != 14) {
                        return 'CPF deve ter 11 dígitos';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  FieldForm(
                    label: 'Rua',
                    isPassword: false,
                    controller: controllerRua,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Rua é obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150,
                        child: FieldForm(
                          label: 'Número',
                          isPassword: false,
                          controller: controllerNumeroCasa,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Número é obrigatório';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: FieldForm(
                          label: 'Bairro',
                          isPassword: false,
                          controller: controllerBairro,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bairro é obrigatório';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FieldForm(
                    label: 'Senha',
                    isPassword: true,
                    controller: controllerSenha,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Senha é obrigatória';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      height: 80,
                      width: 200,
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _insertData(context);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color.fromRGBO(62, 124, 120, 1.0),
                            ),
                          ),
                          child: const Text(
                            'Salvar',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _insertData(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Verificar se o CPF já existe
    final existingUser =
        userProvider.users.firstWhereOrNull((u) => u.cpf == controllerCPF.text);
    if (existingUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CPF já cadastrado")),
      );
      return;
    }

    // Se não existe, inserir o novo usuário
    var id = M.ObjectId();
    final user = MongoDbModel(
      id: id,
      nome: controllerNome.text,
      sobrenome: controllerSobrenome.text,
      email: controllerEmail.text,
      cpf: controllerCPF.text,
      rua: controllerRua.text,
      numeroCasa: controllerNumeroCasa.text,
      bairro: controllerBairro.text,
      senha: controllerSenha.text,
    );

    await userProvider.saveUserToDatabase(user);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Usuário adicionado com sucesso")),
    );
  }
}
