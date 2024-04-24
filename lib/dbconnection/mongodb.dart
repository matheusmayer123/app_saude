import 'dart:developer';

import 'package:app_saude/dbconnection/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDataBase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);

    var status = db.serverStatus();
    print(status);
    var collection = db.collection(COLLECTION_NAME);
    print(await collection.find().toList());
  }
}
