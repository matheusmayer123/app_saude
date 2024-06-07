import 'package:app_saude/pages/edit_consul_page.dart';
import 'package:app_saude/providers/agenda_consulta_provider.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:provider/provider.dart';

class ListaConsulta extends StatefulWidget {
  const ListaConsulta({Key? key}) : super(key: key);

  @override
  State<ListaConsulta> createState() => _ListaConsultaState();
}

class _ListaConsultaState extends State<ListaConsulta> {
  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<AgendaConsultaProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Consultas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: provider.getAllAgendaConsultas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar as consultas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma consulta encontrada'));
          } else {
            // Exibir os dados obtidos do provider
            final consultas = snapshot.data!;
            return ListView.builder(
              itemCount: consultas.length,
              itemBuilder: (context, index) {
                final consultaData = consultas[index];
                return ListTile(
                  title: Text(
                      '${consultaData['especialidade']} - ${consultaData['medico']}'),
                  subtitle: Text(
                      '${consultaData['data'].day}/${consultaData['data'].month}/${consultaData['data'].year} ${consultaData['horario']} - ${consultaData['localizacao']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Navegar para a tela de edição passando os dados da consulta
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditConsultaScreen(
                                  consultaData: consultaData,
                                  onSave: (updatedConsulta) async {
                                    final id = updatedConsulta['_id']
                                        as String; // Assumindo que '_id' é uma String
                                    await provider.updateAgendaConsulta(
                                        id, updatedConsulta);
                                    setState(() {});
                                  } // Atualizar a lista após a edição
                                  ),
                            ),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          final id = consultaData['_id'] as mongo.ObjectId;
                          await provider.deleteAgendaConsulta(id);
                          setState(() {}); // Atualizar a lista após a exclusão
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
