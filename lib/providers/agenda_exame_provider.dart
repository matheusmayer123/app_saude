import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:app_saude/dbconnection/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AgendaExameProvider with ChangeNotifier {
  mongo.Db? _db;
  mongo.DbCollection? _collection;

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

      // Verifique o estado da conexão
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

      // Extrair data, médico e horário do novo exame
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

      // Verificar se já existe um exame para a mesma data, médico e horário
      var examesExistentes = await _collection!.find({
        'data': novaData,
        'medico': novoMedico,
        'horario': novoHorario,
      }).toList();

      // Se houver exames existentes, lançar uma exceção
      if (examesExistentes.isNotEmpty) {
        print(
            'Já existe um exame agendado para o mesmo médico, data e horário.');
        throw Exception(
            'Já existe um exame agendado para o mesmo médico, data e horário.');
      }

      print('Salvando novo exame...');
      // Se não houver exames existentes, inserir o novo exame no banco de dados
      await _collection!.insert({
        ...agendaExame,
        'data': novaData,
        'horario': novoHorario,
      });
      print('Exame salvo com sucesso.');

      // Mostrar Snackbar de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exame agendado com sucesso.'),
          backgroundColor: Colors.green,
        ),
      );

      notifyListeners();
    } catch (e) {
      print('Erro ao agendar exame: $e');

      // Mostrar Snackbar de erro
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
      var agendaExames = await _collection!.find().toList();
      return agendaExames.map((json) => json as Map<String, dynamic>).toList();
    } catch (e) {
      print('Erro ao buscar exames agendados: $e');
      return [];
    }
  }

  Future<void> updateAgendaExame(Map<String, dynamic> updatedExame) async {
    try {
      await _ensureInitialized();
      await _collection!.updateOne(
        mongo.where.id(updatedExame['_id']),
        mongo.modify
            .set('exame', updatedExame['exame'])
            .set('medico', updatedExame['medico'])
            .set('localizacao', updatedExame['localizacao'])
            .set('data', updatedExame['data'])
            .set('horario', updatedExame['horario']),
      );
      notifyListeners();
      print('Exame atualizado com sucesso.');
    } catch (e) {
      print('Erro ao atualizar exame: $e');
    }
  }

  Future<void> deleteAgendaExame(mongo.ObjectId id) async {
    try {
      await _ensureInitialized();
      await _collection!.remove(where.id(id));
      notifyListeners();
      print('Exame deletado com sucesso.');
    } catch (e) {
      print('Erro ao deletar exame: $e');
    }
  }

  Future<bool> verificarHorarioOcupado(DateTime data, TimeOfDay time) async {
    try {
      await _ensureInitialized();
      var exames = await _collection!.find({
        'data': data,
        'horario': _formatTimeOfDay(time),
      }).toList();
      return exames.isNotEmpty; // Retorna true se o horário estiver ocupado
    } catch (e) {
      print('Erro ao verificar horário ocupado para exames: $e');
      return false; // Por padrão, consideramos que o horário está disponível
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
