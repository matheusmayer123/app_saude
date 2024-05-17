// ignore_for_file: prefer_const_constructors
import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/dbconnection/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:app_saude/pages/created_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'field_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerSobrenome = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerCPF = TextEditingController();
  TextEditingController controllerRua = TextEditingController();
  TextEditingController controllerNumeroCasa = TextEditingController();
  TextEditingController controllerBairro = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro',
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
                  label: 'Nome',
                  isPassword: false,
                  controller: controllerNome,
                ),
                const SizedBox(
                  height: 10,
                ),
                FieldForm(
                  label: 'Sobrenome',
                  isPassword: false,
                  controller: controllerSobrenome,
                ),
                const SizedBox(
                  height: 10,
                ),
                FieldForm(
                  label: 'Email',
                  isPassword: false,
                  controller: controllerEmail,
                ),
                const SizedBox(
                  height: 10,
                ),
                FieldForm(
                  label: 'CPF',
                  isPassword: false,
                  controller: controllerCPF,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 250,
                      child: FieldForm(
                        label: 'Rua',
                        isPassword: false,
                        controller: controllerRua,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: FieldForm(
                        label: 'Número',
                        isPassword: false,
                        controller: controllerNumeroCasa,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: FieldForm(
                        label: 'Bairro',
                        isPassword: false,
                        controller: controllerBairro,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                FieldForm(
                  label: 'Senha', // adicionar um confirmar senha depois
                  isPassword: true,
                  controller: controllerSenha,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 80,
                    width: 200,
                    child: Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: TextButton(
                          onPressed: () {
                            _insertData();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ConfirmarEmailContaNova()));
                          },
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromRGBO(62, 124, 120, 1.0))),
                          child: const Text(
                            'Salvar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )),
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

  Future<void> _insertData() async {
    var _id = M.ObjectId();
    final data = MongoDbModel(
        id: _id,
        nome: controllerNome.text,
        sobrenome: controllerSobrenome.text,
        email: controllerEmail.text,
        cpf: controllerCPF.text,
        rua: controllerRua.text,
        numeroCasa: controllerNumeroCasa.text,
        bairro: controllerBairro.text,
        senha: controllerSenha.text);
    var result = await MongoDataBase.insert(data);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Envio Realizado")));
    // _clearAll(); SERVE PARA LIMPAR  OS DADOS DADOS DO FORMULARIO Não é necessario porem deixei aqui caso precise lá pra frente
  }

  // void _clearAll() {
  //   controllerNome.text = "";
  //   controllerSobrenome.text = "";
  //   controllerEmail.text = "";
  //   controllerCPF.text = "";
  //   controllerRua.text = "";
  //   controllerNumeroCasa.text = "";
  //   controllerBairro.text = "";
  //   controllerSenha.text = "";
  // }
}
