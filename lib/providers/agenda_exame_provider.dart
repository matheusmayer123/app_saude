import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:app_saude/dbconnection/constant.dart';

class AgendaExameProvider with ChangeNotifier {
  mongo.Db? _db;
  mongo.DbCollection? _collection;
  List<Map<String, dynamic>>? exames;

  AgendaExameProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      print(
          'Inicializando conexão com o MongoDB para agendamento de exames...');
      _db = await mongo.Db.create(MONGO_URL);
      await _db!.open();
      _collection = _db!.collection(COLLECTION_SCHEDULE_EXAM);
      print('Conexão com o MongoDB para agendamento de exames inicializada.');
      notifyListeners();
    } catch (e) {
      print(
          'Erro ao inicializar conexão com o MongoDB para agendamento de exames: $e');
    }
  }

  Future<void> _ensureInitialized() async {
    try {
      if (_db == null || _collection == null) {
        await _initialize();
      }
      if (_db!.state != mongo.State.OPEN) {
        await _db!.open();
      }
    } catch (e) {
      print(
          'Erro ao garantir inicialização do MongoDB para agendamento de exames: $e');
    }
  }

  Future<void> saveAgendaExameToDatabase(
      Map<String, dynamic> agendaExame, BuildContext context) async {
    try {
      await _ensureInitialized();

      DateTime novaData;
      String novoHorario;
      String novoMedico;

      try {
        novaData = agendaExame['data'];
        novoHorario = agendaExame['horario'];
        novoMedico = agendaExame['medico'];
      } catch (e) {
        throw Exception('Formato incorreto de dados: $e');
      }

      var examesExistentes = await _collection!.find({
        'data': novaData,
        'medico': novoMedico,
        'horario': novoHorario,
      }).toList();

      if (examesExistentes.isNotEmpty) {
        print(
            'Já existe um exame agendado para o mesmo médico, data e horário.');
        throw Exception(
            'Já existe um exame agendado para o mesmo médico, data e horário.');
      }

      print('Salvando novo exame...');
      await _collection!.insert({
        ...agendaExame,
        'data': novaData,
        'horario': novoHorario,
      });
      print('Exame salvo com sucesso.');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exame agendado com sucesso.'),
          backgroundColor: Colors.green,
        ),
      );

      notifyListeners();
    } catch (e) {
      print('Erro ao agendar exame: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao agendar exame: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getAllAgendaExames() async {
    try {
      await _ensureInitialized();
      exames = await _collection!.find().toList();
      notifyListeners();
      return exames ?? [];
    } catch (e) {
      print('Erro ao buscar exames agendados: $e');
      return [];
    }
  }

  Future<bool> verificarHorarioOcupado(DateTime data, TimeOfDay time) async {
    try {
      await _ensureInitialized();
      var exames = await _collection!.find({
        'data': data,
        'horario': _formatTimeOfDay(time),
      }).toList();
      return exames.isNotEmpty;
    } catch (e) {
      print('Erro ao verificar horário ocupado para exames: $e');
      return false;
    }
  }

  Future<void> updateAgendaExame(
      String id, Map<String, dynamic> updatedExame) async {
    try {
      await _ensureInitialized();
      await _collection!.update(
        mongo.where.eq('_id', mongo.ObjectId.parse(id)),
        {'\$set': updatedExame},
      );
      print('Exame atualizado com sucesso.');
      notifyListeners();
    } catch (e) {
      print('Erro ao atualizar exame: $e');
    }
  }

  Future<void> deleteAgendaExame(mongo.ObjectId id) async {
    try {
      await _ensureInitialized();
      await _collection!.remove(mongo.where.id(id));
      notifyListeners();
      print('Exame deletado com sucesso.');
    } catch (e) {
      print('Erro ao deletar exame: $e');
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
