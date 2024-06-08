import 'package:app_saude/providers/medico_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicoProvider = Provider.of<MedicoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Médicos'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Médicos Cadastrados',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: medicoProvider.medicos.length,
                itemBuilder: (context, index) {
                  final medico = medicoProvider.medicos[index];
                  return Card(
                    elevation: 3.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        'Nome: ${medico.nome}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'CRM: ${medico.crm}\nEspecialidade: ${medico.especialidade}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
