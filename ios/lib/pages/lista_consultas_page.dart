import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_saude/providers/agenda_consulta_provider.dart';

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
                          // Adicione a ação para editar a consulta
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          // Adicione a ação para excluir a consulta
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
