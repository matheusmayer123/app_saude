import 'package:app_saude/crm.dart';
import 'package:app_saude/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contatos'),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.contacts.length,
            itemBuilder: (context, index) {
              var contact = provider.contacts[index];
              return ListTile(
                title: Text(contact['name']),
                subtitle: Text(contact['email']),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
