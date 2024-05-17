import 'package:app_saude/dbconnection/mongodb.dart';
import 'package:flutter/material.dart';

class ContactProvider with ChangeNotifier {
  List<Map<String, dynamic>> _contacts = [];

  List<Map<String, dynamic>> get contacts => _contacts;

  Future<void> fetchContacts() async {
    _contacts = await MongoDataBase.getContacts();
    notifyListeners();
  }

  Future<void> addContact(Map<String, dynamic> contact) async {
    await MongoDataBase.insertContact(contact);
    fetchContacts();
  }
}
