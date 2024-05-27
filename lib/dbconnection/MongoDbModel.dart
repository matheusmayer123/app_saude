import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

MongoDbModel mongoDbModelFromJson(String str) =>
    MongoDbModel.fromJson(json.decode(str));

String mongoDbModelToJson(MongoDbModel data) => json.encode(data.toJson());

//Pacientes
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
  ObjectId id;
  String nome;
  String sobrenome;
  String email;
  String cpf;
  String rua;
  String numeroCasa;
  String bairro;
  String senha;
  String crm;

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
  });

  factory MedicoMongoDbModel.fromJson(Map<String, dynamic> json) =>
      MedicoMongoDbModel(
        id: json["_id"] is ObjectId ? json["_id"] : ObjectId.parse(json["_id"]),
        nome: json["Nome"],
        sobrenome: json["Sobrenome"],
        email: json["Email"],
        cpf: json["Cpf"],
        rua: json["Rua"],
        numeroCasa: json["NumeroCasa"],
        bairro: json["Bairro"],
        senha: json["Senha"],
        crm: json["CRM"],
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
        "CRM": crm,
      };
}
