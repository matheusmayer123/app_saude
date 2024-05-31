import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:app_saude/pages/created_account.dart';
import 'package:app_saude/providers/medico_provider.dart';

import '../field_form.dart';

class RegisterPageMedico extends StatefulWidget {
  const RegisterPageMedico({Key? key}) : super(key: key);

  @override
  State<RegisterPageMedico> createState() => _RegisterPageMedicoState();
}

class _RegisterPageMedicoState extends State<RegisterPageMedico> {
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerSobrenome = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerCPF = TextEditingController();
  TextEditingController controllerRua = TextEditingController();
  TextEditingController controllerNumeroCasa = TextEditingController();
  TextEditingController controllerBairro = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();
  TextEditingController controllerCRM = TextEditingController();

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
            child: Column(
              children: [
                FieldForm(
                  label: 'CRM',
                  isPassword: false,
                  controller: controllerCRM,
                ),
                const SizedBox(height: 10),
                FieldForm(
                  label: 'Nome',
                  isPassword: false,
                  controller: controllerNome,
                ),
                const SizedBox(height: 10),
                FieldForm(
                  label: 'Sobrenome',
                  isPassword: false,
                  controller: controllerSobrenome,
                ),
                const SizedBox(height: 10),
                FieldForm(
                  label: 'Email',
                  isPassword: false,
                  controller: controllerEmail,
                ),
                const SizedBox(height: 10),
                FieldForm(
                  label: 'CPF',
                  isPassword: false,
                  controller: controllerCPF,
                ),
                const SizedBox(height: 10),
                FieldForm(
                  label: 'Rua',
                  isPassword: false,
                  controller: controllerRua,
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
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: FieldForm(
                        label: 'Bairro',
                        isPassword: false,
                        controller: controllerBairro,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FieldForm(
                  label: 'Senha',
                  isPassword: true,
                  controller: controllerSenha,
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
                          await _insertData(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ConfirmarEmailContaNova(),
                            ),
                          );
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
    );
  }

  Future<void> _insertData(BuildContext context) async {
    var id = M.ObjectId();
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
    );
    await Provider.of<MedicoProvider>(context, listen: false)
        .saveMedicoToDatabase(medico);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Médico adicionado com sucesso")),
    );
  }
}
