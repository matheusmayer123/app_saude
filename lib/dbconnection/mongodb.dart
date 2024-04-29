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

  static Future<String> insert(MongoDbModel data) async {
    try {
      var result = await collection_Name.insertOne(data.toJson());
      if (result.isSuccess) {
        return "enviado dados";
      } else {
        return "nao foi enviado";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
