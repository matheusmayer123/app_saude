import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:app_saude/dbconnection/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

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

      
      var consultasExistentes = await _collection!.find({
        'data': novaData,
        'medico': novoMedico,
        'horario': novoHorario,
      }).toList();

      
      if (consultasExistentes.isNotEmpty) {
        print(
            'Já existe uma consulta agendada para o mesmo médico, data e horário.');
        throw Exception(
            'Já existe uma consulta agendada para o mesmo médico, data e horário.');
      }

      print('Salvando nova consulta...');
      
      await _collection!.insert({
        ...agendaConsulta,
        'data': novaData,
        'horario': novoHorario,
      });
      print('Consulta salva com sucesso.');

      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Consulta salva com sucesso.'),
          backgroundColor: Colors.green,
        ),
      );

      notifyListeners();
    } catch (e) {
      print('Erro ao salvar consulta: $e');

      
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

  Future<bool> verificarHorarioOcupado(DateTime data, TimeOfDay time) async {
    try {
      await _ensureInitialized();
      var consultas = await _collection!.find({
        'data': data,
        'horario': _formatTimeOfDay(time),
      }).toList();
      return consultas.isNotEmpty; 
    } catch (e) {
      print('Erro ao verificar horário ocupado: $e');
      return false; 
    }
  }

  Future<void> updateAgendaConsulta(
      String id, Map<String, dynamic> updatedConsulta) async {
    try {
      await _ensureInitialized();

      
      await _collection!.update(
        mongo.where.eq('_id', mongo.ObjectId.parse(id)),
        {
          '\$set': updatedConsulta
        }, 
      );

      print('Consulta atualizada com sucesso.');
      notifyListeners();
    } catch (e) {
      print('Erro ao atualizar consulta: $e');
    }
  }

  Future<void> deleteAgendaConsulta(mongo.ObjectId id) async {
    try {
      await _ensureInitialized();
      await _collection!.remove(where.id(id));
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
