import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_saude/dbconnection/medico_provider.dart';

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
    'Pediatria',
    'Oftalmologia',
    'Ortopedia',
    'Neurologia',
    'Ginecologia',
    'Urologia',
    'Oncologia',
  ];

  final List<String> localizacoes = [
    'São Paulo',
    'Rio de Janeiro',
    'Brasília',
    'Belo Horizonte',
    'Salvador',
    'Curitiba',
    'Porto Alegre',
    'Fortaleza',
    'Recife',
  ];

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  List<TimeOfDay> _availableTimes = [];

  void _updateAvailableTimes(DateTime selectedDate) {
    // Aqui você deve implementar a lógica para obter os horários disponíveis
    // para a data selecionada. Suponha que você tenha acesso a essa lógica.
    // Para este exemplo, estou apenas preenchendo uma lista de horários fictícios.
    _availableTimes.clear();
    _availableTimes.add(TimeOfDay(hour: 8, minute: 0));
    _availableTimes.add(TimeOfDay(hour: 9, minute: 0));
    _availableTimes.add(TimeOfDay(hour: 10, minute: 0));
    _availableTimes.add(TimeOfDay(hour: 11, minute: 0));
  }

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
              hint: const Text('Escolha uma especialidade'),
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
              hint: const Text('Escolha uma localização'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLocalizacao = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            Consumer<MedicoProvider>(
              builder: (context, medicoProvider, _) {
                return FutureBuilder<List<MedicoMongoDbModel>>(
                  future: medicoProvider.getAllMedicos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return SizedBox(); // Widget vazio quando ainda está carregando ou não há dados
                    } else if (snapshot.hasError) {
                      return Text(
                          'Erro ao carregar médicos: ${snapshot.error}');
                    } else {
                      List<MedicoMongoDbModel> medicos = snapshot.data!;
                      return DropdownButtonFormField<String>(
                        value: _selectedMedico,
                        items: medicos.map((MedicoMongoDbModel medico) {
                          return DropdownMenuItem<String>(
                            value: '${medico.nome} - CRM: ${medico.crm}',
                            child: Text('${medico.nome} - CRM: ${medico.crm}'),
                          );
                        }).toList(),
                        hint: const Text('Escolha um médico'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedMedico = newValue;
                          });
                        },
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedFormaPagamento,
              items: const [
                DropdownMenuItem(value: 'Dinheiro', child: Text('Dinheiro')),
                DropdownMenuItem(
                    value: 'Cartão de crédito',
                    child: Text('Cartão de crédito')),
                DropdownMenuItem(
                    value: 'Plano de saúde', child: Text('Plano de saúde')),
              ],
              hint: const Text('Escolha uma forma de pagamento'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFormaPagamento = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                    _updateAvailableTimes(_selectedDate!);
                  });
                }
              },
              child: Text(
                _selectedDate == null
                    ? 'Escolha uma data'
                    : 'Data selecionada: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<TimeOfDay>(
              value: _selectedTime,
              items: _availableTimes.map((TimeOfDay time) {
                return DropdownMenuItem<TimeOfDay>(
                  value: time,
                  child: Text(time.format(context)),
                );
              }).toList(),
              hint: const Text('Escolha um horário'),
              onChanged: (TimeOfDay? newValue) {
                setState(() {
                  _selectedTime = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Adicione aqui a lógica para salvar o agendamento com a data e horário selecionados
              },
              child: const Text('Confirmar Agendamento'),
            ),
          ],
        ),
      ),
    );
  }
}
