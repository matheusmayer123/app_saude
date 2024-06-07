import 'package:flutter/material.dart';

class EditExameScreen extends StatefulWidget {
  final Map<String, dynamic> exameData;
  final Function(Map<String, dynamic>) onSave;

  EditExameScreen({required this.exameData, required this.onSave});

  @override
  _EditExameScreenState createState() => _EditExameScreenState();
}

class _EditExameScreenState extends State<EditExameScreen> {
  late TextEditingController _exameController;
  late TextEditingController _medicoController;
  late TextEditingController _localizacaoController;
  late TextEditingController _horarioController;
  DateTime? _data;

  @override
  void initState() {
    super.initState();
    _exameController = TextEditingController(text: widget.exameData['exame']);
    _medicoController = TextEditingController(text: widget.exameData['medico']);
    _localizacaoController =
        TextEditingController(text: widget.exameData['localizacao']);
    _horarioController =
        TextEditingController(text: widget.exameData['horario']);
    _data = widget.exameData['data'];
  }

  @override
  void dispose() {
    _exameController.dispose();
    _medicoController.dispose();
    _localizacaoController.dispose();
    _horarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Exame'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _exameController,
              decoration: InputDecoration(labelText: 'Exame'),
            ),
            TextField(
              controller: _medicoController,
              decoration: InputDecoration(labelText: 'Médico'),
            ),
            TextField(
              controller: _localizacaoController,
              decoration: InputDecoration(labelText: 'Localização'),
            ),
            TextField(
              controller: _horarioController,
              decoration: InputDecoration(labelText: 'Horário'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final updatedExame = {
                  '_id': widget.exameData[
                      '_id'], // Preserve o ID para identificar o documento
                  'exame': _exameController.text,
                  'medico': _medicoController.text,
                  'localizacao': _localizacaoController.text,
                  'data': _data,
                  'horario': _horarioController.text,
                };
                widget.onSave(updatedExame);
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
