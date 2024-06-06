import 'package:app_saude/dbconnection/MongoDbModel.dart';
import 'package:app_saude/pages/csat_page.dart';
import 'package:app_saude/pages/home_page.dart';
import 'package:app_saude/providers/medico_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_saude/providers/agenda_consulta_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
  List<TimeOfDay> _occupiedTimes = [];

  bool _isLoading = false;

  void _updateAvailableTimes(DateTime selectedDate) async {
    _availableTimes.clear();
    _occupiedTimes.clear();
    for (int hour = 8; hour < 20; hour++) {
      var time = TimeOfDay(hour: hour, minute: 0);
      bool isTimeOccupied =
          await Provider.of<AgendaConsultaProvider>(context, listen: false)
              .verificarHorarioOcupado(selectedDate, time);
      if (isTimeOccupied) {
        _occupiedTimes.add(time);
      }
      _availableTimes.add(time);
    }
    setState(() {});
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
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
                      return const SizedBox(); // Widget vazio quando ainda está carregando ou não há dados
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
                DropdownMenuItem(value: 'Pix', child: Text('Pix')),
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
                  locale: const Locale('pt', 'BR'),
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 60)),
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
              items: [
                ..._availableTimes.map((TimeOfDay time) {
                  return DropdownMenuItem<TimeOfDay>(
                    value: time,
                    child: Text(
                      _formatTimeOfDay(time),
                      style: TextStyle(
                        color: _occupiedTimes.contains(time)
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  );
                }),
              ],
              hint: const Text('Escolha um horário'),
              onChanged: (TimeOfDay? newValue) {
                setState(() {
                  _selectedTime = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                      if (_selectedEspecialidade != null &&
                          _selectedLocalizacao != null &&
                          _selectedMedico != null &&
                          _selectedFormaPagamento != null &&
                          _selectedDate != null &&
                          _selectedTime != null) {
                        setState(() {
                          _isLoading = true;
                        });

                        final newAppointment = {
                          'especialidade': _selectedEspecialidade,
                          'localizacao': _selectedLocalizacao,
                          'medico': _selectedMedico,
                          'forma_pagamento': _selectedFormaPagamento,
                          'data': _selectedDate,
                          'horario': _selectedTime?.format(context),
                        };

                        try {
                          await Provider.of<AgendaConsultaProvider>(context,
                                  listen: false)
                              .saveAgendaConsultaToDatabase(
                                  newAppointment, context);

                          setState(() {
                            _isLoading = false;
                          });

                          // Atrasar a exibição do pop-up em 2 segundos
                          Future.delayed(Duration(seconds: 2), () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      'O que está achando do nosso aplicativo?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage()),
                                          (Route<dynamic> route) => false,
                                        );
                                      },
                                      child: Text('Voltar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PesquisaSatisfacao()),
                                        );
                                      },
                                      child: Text('Responder'),
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        } catch (e) {
                          // Lidar com qualquer erro aqui
                          setState(() {
                            _isLoading = false;
                          });
                          print('Erro ao salvar agendamento: $e');
                        }
                      } else {
                        print('Preencha todos os campos');
                      }
                    },
                    child: const Text('Confirmar Agendamento'),
                  ),
          ],
        ),
      ),
    );
  }
}
