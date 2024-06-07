import 'package:app_saude/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/providers/user_provider.dart';

class PerfilDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final MongoDbModel? loggedInUser = userProvider.loggedInUser;

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
                  onTap: () {},
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
          if (loggedInUser != null) ...[
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Nome: ${loggedInUser.nome}'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Sobrenome: ${loggedInUser.sobrenome}'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email: ${loggedInUser.email}'),
            ),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('CPF: ${loggedInUser.cpf}'),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Rua: ${loggedInUser.rua}'),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Número da Casa: ${loggedInUser.numeroCasa}'),
            ),
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text('Bairro: ${loggedInUser.bairro}'),
            ),
          ] else ...[
            ListTile(
              title: Text('Nenhum usuário logado'),
            ),
          ],
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
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
