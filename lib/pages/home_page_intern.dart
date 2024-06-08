import 'package:app_saude/pages/agenda_consulta.dart';
import 'package:app_saude/pages/agenda_exame.dart';
import 'package:app_saude/pages/avaliacoes_page.dart';
import 'package:app_saude/pages/crm_chart_page.dart';
import 'package:app_saude/pages/lista_consultas_page.dart';
import 'package:app_saude/pages/lista_exame.dart';
import 'package:app_saude/pages/lista_med_page.dart';
import 'package:app_saude/pages/perfil_drawer.dart';
import 'package:app_saude/pages/qr_code_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:app_saude/providers/agenda_consulta_provider.dart';
import 'package:app_saude/providers/agenda_exame_provider.dart';
import 'package:intl/intl.dart'; // Importante para formatação de data

class HomePageIntern extends StatefulWidget {
  const HomePageIntern({Key? key}) : super(key: key);

  @override
  State<HomePageIntern> createState() => _HomePageInternState();
}

class _HomePageInternState extends State<HomePageIntern> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch data when the HomePageIntern initializes
    final consultaProvider =
        Provider.of<AgendaConsultaProvider>(context, listen: false);
    consultaProvider.getAllAgendaConsultas();

    final exameProvider =
        Provider.of<AgendaExameProvider>(context, listen: false);
    exameProvider.getAllAgendaExames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instituto De Saúde Especializado'),
        centerTitle: true,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromRGBO(62, 124, 120, 1.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Consumer2<AgendaConsultaProvider, AgendaExameProvider>(
                builder: (context, consultaProvider, exameProvider, child) {
                  final consultas = consultaProvider.consultas ?? [];
                  final exames = exameProvider.exames ?? [];

                  final allItems = [...consultas, ...exames];

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: allItems.map((item) {
                        final String tipo = item['type'] ?? '';

                        String titulo;
                        Color corTitulo;

                        if (tipo == 'consulta') {
                          titulo = 'Consulta';
                          corTitulo = Colors.blue;
                        } else {
                          titulo = 'Exame';
                          corTitulo = Colors.green;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              if (details.delta.dx > 0) {
                                // Swipe da direita para a esquerda
                                // Lógica para rolar para a esquerda
                                Scrollable.ensureVisible(context);
                              } else if (details.delta.dx < 0) {
                                // Swipe da esquerda para a direita
                                // Lógica para rolar para a direita
                                Scrollable.ensureVisible(context);
                              }
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child: Container(
                                width: 250, // Largura fixa para cada card
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      titulo,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: corTitulo,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Corrigido para usar diretamente DateTime
                                    Text(
                                      'Data: ${_formatDate(item['data'] as DateTime)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      'Horário: ${item['horario']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      'Médico: ${item['medico']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: <Widget>[
                buildGridItem(
                  icon: CupertinoIcons.calendar_badge_plus,
                  label: 'Agendar Consulta',
                  page: AgendaConsultaPage(),
                ),
                buildGridItem(
                  icon: CupertinoIcons.doc_text_viewfinder,
                  label: 'CRM',
                  page: CrmChart(),
                ),
                buildGridItem(
                  icon: CupertinoIcons.square_favorites_alt_fill,
                  label: 'Pesquisa de Satisfação',
                  page: AvaliacoesPage(),
                ),
                buildGridItem(
                  icon: CupertinoIcons.lab_flask,
                  label: 'Agendar Exames',
                  page: AgendaExamePage(),
                ),
                buildGridItem(
                  icon: CupertinoIcons.doc_on_clipboard,
                  label: 'Lista De Médicos',
                  page: MedicoScreen(),
                ),
                buildGridItem(
                  icon: CupertinoIcons.lab_flask_solid,
                  label: 'Lista de Exames',
                  page: ListaExame(),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Lista de Consultas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Conta',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(62, 124, 120, 1.0),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildGridItem({
    required IconData icon,
    required String label,
    required Widget page,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.black,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      switch (_selectedIndex) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePageIntern()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListaConsulta()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PerfilDrawer()),
          );
          break;
      }
    });
  }

  // Função para formatar a data
  String _formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }
}
