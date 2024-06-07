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
  String? imageUrl;

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
    this.imageUrl,
  });

  MongoDbModel copyWith({
    ObjectId? id,
    String? nome,
    String? sobrenome,
    String? email,
    String? cpf,
    String? rua,
    String? numeroCasa,
    String? bairro,
    String? senha,
    String? imageUrl,
  }) {
    return MongoDbModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      sobrenome: sobrenome ?? this.sobrenome,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      rua: rua ?? this.rua,
      numeroCasa: numeroCasa ?? this.numeroCasa,
      bairro: bairro ?? this.bairro,
      senha: senha ?? this.senha,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

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
        imageUrl: json["imageUrl"],
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
        "imageUrl": imageUrl,
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
  String especialidade; // Adicionando o campo especialidade

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
        especialidade: json[
            "Especialidade"], // Adicionando a leitura do campo especialidade
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
        "Especialidade":
            especialidade, // Adicionando o campo especialidade ao JSON
      };
}
