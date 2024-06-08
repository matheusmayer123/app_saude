import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:collection/collection.dart';

import '../field_form.dart';
import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/pages/created_account.dart';
import 'package:app_saude/providers/medico_provider.dart';

class RegisterPageMedico extends StatefulWidget {
  const RegisterPageMedico({Key? key}) : super(key: key);

  @override
  _RegisterPageMedicoState createState() => _RegisterPageMedicoState();
}

class _RegisterPageMedicoState extends State<RegisterPageMedico> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerSobrenome = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  var controllerCPF = MaskedTextController(mask: '000.000.000-00');
  TextEditingController controllerRua = TextEditingController();
  TextEditingController controllerNumeroCasa = TextEditingController();
  TextEditingController controllerBairro = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();
  TextEditingController controllerEspecialidade = TextEditingController();
  MaskedTextController controllerCRM = MaskedTextController(mask: '00000');

  List<String> estados = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ];
  String? selectedEstado;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
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
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FieldForm(
                  label: 'CRM',
                  isPassword: false,
                  controller: controllerCRM,
                  validator: (value) {
                    final crm = controllerCRM.text;
                    if (crm.isEmpty) {
                      return 'CRM é obrigatório';
                    }
                    if (crm.length != 5 || int.tryParse(crm) == null) {
                      return 'CRM deve ter 5 dígitos numéricos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedEstado,
                  onChanged: (value) {
                    setState(() {
                      selectedEstado = value;
                    });
                  },
                  items: estados.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Color.fromRGBO(67, 136, 131, 1.0),
                        ),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Estado',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(67, 136, 131, 1.0),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(67, 136, 131, 1.0),
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Estado é obrigatório';
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
                    final cpf = controllerCPF.text;
                    if (cpf.isEmpty) {
                      return 'CPF é obrigatório';
                    }
                    if (cpf.length != 14) {
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
                      return 'Rua é obrigatória';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
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
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
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
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final success = await _insertData(context);
                      if (success) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ConfirmarEmailContaNova(),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(62, 124, 120, 1.0),
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 20),
                    minimumSize: const Size(200, 80),
                  ),
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _insertData(BuildContext context) async {
    var id = ObjectId();
    final medico = MedicoMongoDbModel(
      id: id,
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
    final medicoProvider = Provider.of<MedicoProvider>(context, listen: false);

    
    final existingMedicoCPF =
        medicoProvider.medicos.firstWhereOrNull((m) => m.cpf == medico.cpf);
    if (existingMedicoCPF != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CPF já cadastrado")),
      );
      return false;
    }

    
    final existingMedicoCRM =
        medicoProvider.medicos.firstWhereOrNull((m) => m.crm == medico.crm);
    if (existingMedicoCRM != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CRM já cadastrado")),
      );
      return false;
    }

    
    await medicoProvider.saveMedicoToDatabase(medico);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Médico adicionado com sucesso")),
    );
    return true;
  }

  String _generateCRM(String crmPrefix) {
    if (selectedEstado != null) {
      return '$crmPrefix-${selectedEstado!}';
    }
    return crmPrefix;
  }
}
