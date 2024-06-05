import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:app_saude/dbconnection/constant.dart';

class AgendaConsultaProvider with ChangeNotifier {
  mongo.Db? _db;
  mongo.DbCollection? _collection;

  AgendaConsultaProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      print('Inicializando conexão com o MongoDB...');
      _db = await mongo.Db.create(MONGO_URL);
      await _db!.open();
      _collection = _db!.collection(COLLECTION_SCHEDULE);
      print('Conexão com o MongoDB inicializada.');
      notifyListeners();
    } catch (e) {
      print('Erro ao inicializar conexão com o MongoDB: $e');
    }
  }

  Future<void> _ensureInitialized() async {
    try {
      if (_db == null || _collection == null) {
        await _initialize();
      }

      // Verifique o estado da conexão
      if (_db!.state != mongo.State.OPEN) {
        await _db!.open();
      }
    } catch (e) {
      print('Erro ao garantir inicialização do MongoDB: $e');
    }
  }

  Future<void> saveAgendaConsultaToDatabase(
      Map<String, dynamic> agendaConsulta, BuildContext context) async {
    try {
      await _ensureInitialized();

      // Extrair data, médico e horário da nova consulta
      DateTime novaData;
      String novoHorario;
      String novoMedico;

      try {
        novaData = agendaConsulta['data'];
        novoHorario = agendaConsulta['horario'];
        novoMedico = agendaConsulta['medico'];
      } catch (e) {
        throw Exception('Formato incorreto de dados: $e');
      }

      // Verificar se já existe uma consulta para a mesma data, médico e horário
      var consultasExistentes = await _collection!.find({
        'data': novaData,
        'medico': novoMedico,
        'horario': novoHorario,
      }).toList();

      // Se houver consultas existentes, lançar uma exceção
      if (consultasExistentes.isNotEmpty) {
        print(
            'Já existe uma consulta agendada para o mesmo médico, data e horário.');
        throw Exception(
            'Já existe uma consulta agendada para o mesmo médico, data e horário.');
      }

      print('Salvando nova consulta...');
      // Se não houver consultas existentes, inserir a nova consulta no banco de dados
      await _collection!.insert({
        ...agendaConsulta,
        'data': novaData,
        'horario': novoHorario,
      });
      print('Consulta salva com sucesso.');

      // Mostrar Snackbar de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Consulta salva com sucesso.'),
          backgroundColor: Colors.green,
        ),
      );

      notifyListeners();
    } catch (e) {
      print('Erro ao salvar consulta: $e');

      // Mostrar Snackbar de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar consulta: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getAllAgendaConsultas() async {
    try {
      await _ensureInitialized();
      var agendaConsultas = await _collection!.find().toList();
      return agendaConsultas
          .map((json) => json as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Erro ao buscar consultas: $e');
      return [];
    }
  }
}
