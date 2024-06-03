import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'MongoDbModel.dart';
import 'constant.dart';

class MongoDataBase {
  static Db? _db;
  static DbCollection? _collection;

  static Future<void> connect() async {
    _db = await Db.create(MONGO_URL);
    await _db?.open();
    _collection = _db?.collection(COLLECTION_NAME);
  }

  static Future<List<Map<String, dynamic>>> getUser() async {
    try {
      return await _collection?.find().toList() ?? [];
    } catch (e) {
      log('Error fetching contacts: $e');
      return [];
    }
  }

  static Future<String> insertUser(MongoDbModel data) async {
    try {
      var result = await _collection?.insertOne(data.toJson());
      if (result?.isSuccess == true) {
        return "Dados enviados com sucesso";
      } else {
        return "Falha ao enviar dados";
      }
    } catch (e) {
      log('Error inserting data: $e');
      return e.toString();
    }
  }

  static Future<void> deleteUser(Map<String, dynamic> contact) async {
    try {
      await _collection?.remove(where.eq('_id', contact['_id']));
    } catch (e) {
      log('Error deleting contact: $e');
    }
  }

  static Future<void> updateUser(
      ObjectId id, Map<String, dynamic> updatedContact) async {
    try {
      await _collection?.update(where.id(id), updatedContact);
    } catch (e) {
      log('Error updating contact: $e');
    }
  }
}
