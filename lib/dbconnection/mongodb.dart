import 'dart:developer';

import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/dbconnection/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDataBase {
  static var db, collection_Name;
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    collection_Name = db.collection(COLLECTION_NAME);
    await db.open();
  }

  static Future<void> insertContact(Map<String, dynamic> contact) async {
    await collection_Name?.insert(contact);
  }

  static Future<List<Map<String, dynamic>>> getContacts() async {
    return await collection_Name?.find().toList() ?? [];
  }

  static Future<String> insert(MongoDbModel data) async {
    try {
      var result = await collection_Name.insertOne(data.toJson());
      if (result.isSuccess) {
        return "enviado dadossss";
      } else {
        return "nao foi enviadooo";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
