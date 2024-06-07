import 'package:app_saude/providers/satisfacao_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_saude/providers/agenda_consulta_provider.dart';

class AvaliacoesPage extends StatefulWidget {
  @override
  _AvaliacoesPageState createState() => _AvaliacoesPageState();
}

class _AvaliacoesPageState extends State<AvaliacoesPage> {
  String? selectedMode;
  String? pontuacao;
  DateTime? dataInicial;
  DateTime? dataFinal;

  final TextEditingController dataInicialController = TextEditingController();
  final TextEditingController dataFinalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliações dos Usuários'),
      ),
      body: Consumer<SatisfacaoProvider>(
        builder: (context, provider, _) {
          if (provider == null || provider.satisfacoes == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _buildAvaliacoesList(provider.satisfacoes);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFilterDialog(context);
        },
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildAvaliacoesList(List<Map<String, dynamic>> avaliacoes) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: avaliacoes.length,
            itemBuilder: (context, index) {
              final avaliacao = avaliacoes[index];
              final date = avaliacao['date'] as DateTime?;
              final dateString = date != null
                  ? '${date.day}/${date.month}/${date.year}'
                  : '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'; // Usar a data atual se a data da avaliação for nula

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  title: Text('Pontuação: ${avaliacao['rating']}'),
                  subtitle: Text(avaliacao['observation']),
                  trailing: Text(
                    dateString,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    // Ação ao tocar na avaliação, por exemplo, exibir detalhes
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrar Avaliações'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Modo de Pesquisa:'),
                DropdownButtonFormField<String>(
                  value: selectedMode,
                  onChanged: (value) {
                    setState(() {
                      selectedMode = value;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      child: Text('Maior que'),
                      value: 'maior',
                    ),
                    DropdownMenuItem(
                      child: Text('Menor que'),
                      value: 'menor',
                    ),
                    DropdownMenuItem(
                      child: Text('Igual a'),
                      value: 'igual',
                    ),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Modo de Pesquisa',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      pontuacao = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Pontuação',
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Período de Tempo:'),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        controller: dataInicialController,
                        decoration: const InputDecoration(
                          labelText: 'De (dd/mm/yyyy)',
                        ),
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              dataInicial = selectedDate;
                              dataInicialController.text =
                                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        controller: dataFinalController,
                        decoration: const InputDecoration(
                          labelText: 'Até (dd/mm/yyyy)',
                        ),
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              dataFinal = selectedDate;
                              dataFinalController.text =
                                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                _applyFilters(context);
              },
              child: const Text('Filtrar'),
            ),
          ],
        );
      },
    );
  }

  void _applyFilters(BuildContext context) async {
    final provider =
        Provider.of<AgendaConsultaProvider>(context, listen: false);
    final consultas = await provider.getAllAgendaConsultas();

    print('Consultas recebidas: $consultas');
    print('Data Inicial: $dataInicial');
    print('Data Final: $dataFinal');

    final consultasFiltradasPorPontuacao =
        filtrarPorPontuacao(consultas, selectedMode, pontuacao);

    print('Consultas filtradas por pontuação: $consultasFiltradasPorPontuacao');

    final consultasFiltradasPorDatas =
        filtrarPorDatas(consultasFiltradasPorPontuacao, dataInicial, dataFinal);

    print('Consultas filtradas por datas: $consultasFiltradasPorDatas');

    if (consultasFiltradasPorDatas.isNotEmpty) {
      print('Consultas filtradas: $consultasFiltradasPorDatas');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sem Resultados'),
            content:
                const Text('Não há consultas com os critérios selecionados.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  List<Map<String, dynamic>> filtrarPorDatas(
      List<Map<String, dynamic>> consultas,
      DateTime? dataInicial,
      DateTime? dataFinal) {
    if (dataInicial == null || dataFinal == null) {
      return consultas;
    }

    return consultas.where((consulta) {
      final consultaDate = consulta['date'] as DateTime?;
      return consultaDate != null &&
          consultaDate.isAfter(dataInicial.subtract(const Duration(days: 1))) &&
          consultaDate.isBefore(dataFinal.add(const Duration(days: 1)));
    }).toList();
  }

  List<Map<String, dynamic>> filtrarPorPontuacao(
      List<Map<String, dynamic>> consultas,
      String? selectedMode,
      String? pontuacao) {
    if (selectedMode == null || pontuacao == null || pontuacao.isEmpty) {
      return consultas;
    }

    double pontuacaoDouble = double.tryParse(pontuacao) ?? 0;

    switch (selectedMode) {
      case 'maior':
        return consultas
            .where((consulta) =>
                ((consulta['rating'] as num?) ?? 0) > pontuacaoDouble)
            .toList();
      case 'menor':
        return consultas
            .where((consulta) =>
                ((consulta['rating'] as num?) ?? 0) < pontuacaoDouble)
            .toList();
      case 'igual':
        return consultas
            .where((consulta) =>
                ((consulta['rating'] as num?) ?? 0) == pontuacaoDouble)
            .toList();
      default:
        return consultas;
    }
  }
}
