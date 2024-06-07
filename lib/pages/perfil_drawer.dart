import 'package:app_saude/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/providers/user_provider.dart';

class PerfilDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final List<MongoDbModel> users = userProvider.users;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.greenAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _showImageLinkDialog(context);
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 50,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Informações do Usuário',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Nome: ${users.isNotEmpty ? users[0].nome : ''}'),
            onTap: () {
              // Implement action
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
                'Sobrenome: ${users.isNotEmpty ? users[0].sobrenome : ''}'),
            onTap: () {
              // Implement action
            },
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Email: ${users.isNotEmpty ? users[0].email : ''}'),
            onTap: () {
              // Implement action
            },
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('CPF: ${users.isNotEmpty ? users[0].cpf : ''}'),
            onTap: () {
              // Implement action
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Rua: ${users.isNotEmpty ? users[0].rua : ''}'),
            onTap: () {
              // Implement action
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
                'Número da Casa: ${users.isNotEmpty ? users[0].numeroCasa : ''}'),
            onTap: () {
              // Implement action
            },
          ),
          ListTile(
            leading: Icon(Icons.location_city),
            title: Text('Bairro: ${users.isNotEmpty ? users[0].bairro : ''}'),
            onTap: () {
              // Implement action
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text('Voltar'),
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer
            },
          ),
        ],
      ),
    );
  }

  void _showImageLinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Inserir Link da Foto de Perfil"),
          content: TextField(
            decoration: InputDecoration(hintText: "Insira o link aqui"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Salvar"),
              onPressed: () {
                // Aqui você pode salvar o link da imagem
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
