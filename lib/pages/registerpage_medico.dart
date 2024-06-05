import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/pages/created_account.dart';
import 'package:app_saude/providers/medico_provider.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../field_form.dart';

class RegisterPageMedico extends StatefulWidget {
  const RegisterPageMedico({Key? key}) : super(key: key);

  @override
  State<RegisterPageMedico> createState() => _RegisterPageMedicoState();
}

class _RegisterPageMedicoState extends State<RegisterPageMedico> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerSobrenome = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  var controllerCPF = MaskedTextController(mask: '000.000.000-00');
  var controllerCRM = MaskedTextController(mask: '00000-AA');
  TextEditingController controllerRua = TextEditingController();
  TextEditingController controllerNumeroCasa = TextEditingController();
  TextEditingController controllerBairro = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();
  TextEditingController controllerEspecialidade = TextEditingController();

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
          'Cadastro de Médico',
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
                    label: 'CRM',
                    isPassword: false,
                    controller: controllerCRM,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CRM é obrigatório';
                      }
                      // Converter os últimos dois caracteres para maiúsculo
                      String crmUpperCase = value.toUpperCase();
                      // Verificar se o CRM está no formato correto '12345-XX'
                      final regex = RegExp(r'^\d{5}-[A-Z]{2}$');
                      if (!regex.hasMatch(crmUpperCase)) {
                        return 'CRM deve estar no formato 12345-XX';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  FieldForm(
                    label: 'Especialidade',
                    isPassword: false,
                    controller: controllerEspecialidade,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Especialidade é obrigatória';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ConfirmarEmailContaNova(),
                                ),
                              );
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
    var id = M.ObjectId();
    final medico = MedicoMongoDbModel(
      id: '',
      nome: controllerNome.text,
      sobrenome: controllerSobrenome.text,
      email: controllerEmail.text,
      cpf: controllerCPF.text,
      rua: controllerRua.text,
      numeroCasa: controllerNumeroCasa.text,
      bairro: controllerBairro.text,
      senha: controllerSenha.text,
      crm: controllerCRM.text,
      especialidade: controllerEspecialidade.text,
    );
    await Provider.of<MedicoProvider>(context, listen: false)
        .saveMedicoToDatabase(medico);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Médico adicionado com sucesso")),
    );
  }
}
