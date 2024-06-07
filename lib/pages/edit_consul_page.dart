import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_saude/providers/agenda_consulta_provider.dart';
import 'package:intl/intl.dart';

class EditConsultaScreen extends StatefulWidget {
  final Map<String, dynamic> consultaData;
  final Function(Map<String, dynamic>) onSave;

  EditConsultaScreen({
    required this.consultaData,
    required this.onSave,
  });

  @override
  _EditConsultaScreenState createState() => _EditConsultaScreenState();
}

class _EditConsultaScreenState extends State<EditConsultaScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _especialidadeController;
  late TextEditingController _medicoController;
  late TextEditingController _dataController;
  late TextEditingController _horarioController;
  late TextEditingController _localizacaoController;

  @override
  void initState() {
    super.initState();

    // Inicializar os controladores com os dados da consulta
    _especialidadeController =
        TextEditingController(text: widget.consultaData['especialidade']);
    _medicoController =
        TextEditingController(text: widget.consultaData['medico']);

    // Converter o valor de 'data' para uma String formatada
    final data = widget.consultaData['data'] as DateTime;
    final dataFormatada = DateFormat('MMMM dd, yyyy', 'pt_BR').format(data);
    _dataController = TextEditingController(text: dataFormatada);

    _horarioController =
        TextEditingController(text: widget.consultaData['horario']);
    _localizacaoController =
        TextEditingController(text: widget.consultaData['localizacao']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Consulta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _especialidadeController,
                decoration: InputDecoration(labelText: 'Especialidade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a especialidade';
                  }
                  return null;
                },
              ),
              // Repita para os outros campos de dados da consulta
              // Adicione campos para o médico, data, horário e localização
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Criar um mapa com os dados atualizados da consulta
                    final updatedConsulta = {
                      'especialidade': _especialidadeController.text,
                      'medico': _medicoController.text,
                      'data': _dataController.text,
                      'horario': _horarioController.text,
                      'localizacao': _localizacaoController.text,
                      // Adicione outros campos conforme necessário
                    };

                    // Chamar a função onSave para salvar os dados atualizados
                    widget.onSave(updatedConsulta);

                    // Fechar a tela de edição
                    Navigator.pop(context);
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Limpar os controladores quando a tela for descartada
    _especialidadeController.dispose();
    _medicoController.dispose();
    _dataController.dispose();
    _horarioController.dispose();
    _localizacaoController.dispose();
    super.dispose();
  }
}
