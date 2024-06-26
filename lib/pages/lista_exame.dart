import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import 'package:provider/provider.dart';
import 'package:app_saude/providers/agenda_exame_provider.dart'; 

class ListaExame extends StatefulWidget {
  const ListaExame({Key? key}) : super(key: key);

  @override
  State<ListaExame> createState() => _ListaExameState();
}

class _ListaExameState extends State<ListaExame> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AgendaExameProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Exames'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: provider.getAllAgendaExames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os exames'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum exame encontrado'));
          } else {
            
            final exames = snapshot.data!;
            return ListView.builder(
              itemCount: exames.length,
              itemBuilder: (context, index) {
                final exameData = exames[index];

                
                print('Exame Data: $exameData');

                return ListTile(
                  title: Text(
                      '${exameData['exame'] ?? 'Exame não informado'} - ${exameData['medico']}'),
                  subtitle: Text(
                      '${DateTime.parse(exameData['data'].toString()).day}/${DateTime.parse(exameData['data'].toString()).month}/${DateTime.parse(exameData['data'].toString()).year} ${exameData['horario']} - ${exameData['localizacao']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final id = exameData['_id'] as mongo.ObjectId;
                          await provider.deleteAgendaExame(id);
                          setState(() {}); 
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
