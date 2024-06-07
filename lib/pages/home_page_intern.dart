import 'package:app_saude/pages/agenda_consulta.dart';
import 'package:app_saude/pages/agenda_exame.dart';
import 'package:app_saude/pages/avaliacoes_page.dart';
import 'package:app_saude/pages/crm_chart_page.dart';
import 'package:app_saude/pages/lista_consultas_page.dart';
import 'package:app_saude/pages/lista_exame.dart';
import 'package:app_saude/pages/lista_med_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageIntern extends StatefulWidget {
  const HomePageIntern({Key? key}) : super(key: key);

  @override
  State<HomePageIntern> createState() => _HomePageInternState();
}

class _HomePageInternState extends State<HomePageIntern> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instituto De Saúde Especializado'),
        centerTitle: true,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromRGBO(62, 124, 120, 1.0),
      ),
      body: Column(
        children: [
          Container(
            height: 125,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                buildCard(),
                const SizedBox(width: 20),
                buildCard(),
                const SizedBox(width: 20),
                buildCard(),
                const SizedBox(width: 20),
                buildCard(),
                const SizedBox(width: 20),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: <Widget>[
                buildGridItem(
                  icon: CupertinoIcons.calendar_badge_plus,
                  label: 'Agendar Consulta',
                  page: AgendaConsultaPage(
                      /* userName: nomeDoUsuario, */
                      ),
                ),
                buildGridItem(
                  icon: CupertinoIcons.doc_text_viewfinder,
                  label: 'CRM',
                  page: CrmChart(),
                ),
                buildGridItem(
                  icon: CupertinoIcons.lab_flask,
                  label: 'Agendar Exames',
                  page: AgendaExamePage(),
                ),
                buildGridItem(
                  icon: CupertinoIcons.doc_on_clipboard,
                  label: 'Lita De Médicos',
                  page: MedicoScreen(),
                ),
                buildGridItem(
                  icon: CupertinoIcons.exclamationmark_bubble_fill,
                  label: 'Urgência',
                  page: AgendaConsultaPage(),
                ),
                buildGridItem(
                  icon: CupertinoIcons.lab_flask_solid,
                  label: 'Lista de Exames',
                  page: ListaExame(),
                ),
              ],
            ),
          ),
        ],
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

  Widget buildCard() => Container(
        width: 150,
        height: 100,
        color: Colors.red,
      );

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
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.black,
              size: 50,
            ),
            Text(label),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navega para outra página com base no índice selecionado
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
            MaterialPageRoute(builder: (context) => AvaliacoesPage()),
          );
          break;
      }
    });
  }
}
