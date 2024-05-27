import 'package:flutter/material.dart';

class AgendaConsultaPage extends StatefulWidget {
  const AgendaConsultaPage({Key? key}) : super(key: key);

  @override
  State<AgendaConsultaPage> createState() => _AgendaConsultaPageState();
}

class _AgendaConsultaPageState extends State<AgendaConsultaPage> {
  String? _selectedEspecialidade;
  String? _selectedLocalizacao;
  String? _selectedMedico;
  String? _selectedFormaPagamento;

  final List<String> especialidades = [
    'Cardiologia',
    'Dermatologia',
    'Pediatria'
  ];
  final List<String> localizacoes = ['São Paulo', 'Rio de Janeiro', 'Brasília'];
  final List<String> medicos = ['Dr. João', 'Dra. Maria', 'Dr. Pedro'];
  final List<String> formasPagamento = [
    'Dinheiro',
    'Cartão de crédito',
    'Plano de saúde'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Consultas'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedEspecialidade,
              items: especialidades.map((String especialidade) {
                return DropdownMenuItem<String>(
                  value: especialidade,
                  child: Text(especialidade),
                );
              }).toList(),
              hint: Text('Escolha uma especialidade'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedEspecialidade = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedLocalizacao,
              items: localizacoes.map((String localizacao) {
                return DropdownMenuItem<String>(
                  value: localizacao,
                  child: Text(localizacao),
                );
              }).toList(),
              hint: Text('Escolha uma localização'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLocalizacao = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedMedico,
              items: medicos.map((String medico) {
                return DropdownMenuItem<String>(
                  value: medico,
                  child: Text(medico),
                );
              }).toList(),
              hint: Text('Escolha um médico'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMedico = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedFormaPagamento,
              items: formasPagamento.map((String forma) {
                return DropdownMenuItem<String>(
                  value: forma,
                  child: Text(forma),
                );
              }).toList(),
              hint: Text('Escolha uma forma de pagamento'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFormaPagamento = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
