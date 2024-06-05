import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

MongoDbModel mongoDbModelFromJson(String str) =>
    MongoDbModel.fromJson(json.decode(str));

String mongoDbModelToJson(MongoDbModel data) => json.encode(data.toJson());

//pacientes
class MongoDbModel {
  ObjectId id;
  String nome;
  String sobrenome;
  String email;
  String cpf;
  String rua;
  String numeroCasa;
  String bairro;
  String senha;

  MongoDbModel({
    required this.id,
    required this.nome,
    required this.sobrenome,
    required this.email,
    required this.cpf,
    required this.rua,
    required this.numeroCasa,
    required this.bairro,
    required this.senha,
  });

  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
        id: json["_id"] is ObjectId ? json["_id"] : ObjectId.parse(json["_id"]),
        nome: json["Nome"],
        sobrenome: json["Sobrenome"],
        email: json["Email"],
        cpf: json["Cpf"],
        rua: json["Rua"],
        numeroCasa: json["NumeroCasa"],
        bairro: json["Bairro"],
        senha: json["Senha"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "Nome": nome,
        "Sobrenome": sobrenome,
        "Email": email,
        "Cpf": cpf,
        "Rua": rua,
        "NumeroCasa": numeroCasa,
        "Bairro": bairro,
        "Senha": senha,
      };
}

//Medicos

class MedicoMongoDbModel {
  String id; // Alteração do tipo para String
  String nome;
  String sobrenome;
  String email;
  String cpf;
  String rua;
  String numeroCasa;
  String bairro;
  String senha;
  String crm;
  String especialidade;

  MedicoMongoDbModel({
    required this.id,
    required this.nome,
    required this.sobrenome,
    required this.email,
    required this.cpf,
    required this.rua,
    required this.numeroCasa,
    required this.bairro,
    required this.senha,
    required this.crm,
    required this.especialidade,
  });

  factory MedicoMongoDbModel.fromJson(Map<String, dynamic> json) {
    return MedicoMongoDbModel(
      id: json["_id"].toString(), // Alteração para String
      nome: json["Nome"],
      sobrenome: json["Sobrenome"],
      email: json["Email"],
      cpf: json["Cpf"],
      rua: json["Rua"],
      numeroCasa: json["NumeroCasa"],
      bairro: json["Bairro"],
      senha: json["Senha"],
      crm: json["CRM"],
      especialidade: json["Especialidade"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "Nome": nome,
        "Sobrenome": sobrenome,
        "Email": email,
        "Cpf": cpf,
        "Rua": rua,
        "NumeroCasa": numeroCasa,
        "Bairro": bairro,
        "Senha": senha,
        "CRM": crm,
        "Especialidade": especialidade,
      };
}
