import 'package:app_saude/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_saude/providers/satisfacao_provider.dart'; // Importe o SatisfacaoProvider

class PesquisaSatisfacao extends StatefulWidget {
  const PesquisaSatisfacao({Key? key}) : super(key: key);

  @override
  State<PesquisaSatisfacao> createState() => _PesquisaSatisfacaoState();
}

class _PesquisaSatisfacaoState extends State<PesquisaSatisfacao> {
  double _rating = 0;
  final TextEditingController _observationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliação do Aplicativo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Por favor, avalie sua experiência:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Slider(
              value: _rating,
              min: 0,
              max: 5,
              divisions: 5,
              label: _rating.toString(),
              onChanged: (double value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _observationController,
              decoration: const InputDecoration(
                labelText: 'Observação (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Use Provider.of para acessar o SatisfacaoProvider
                final provider =
                    Provider.of<SatisfacaoProvider>(context, listen: false);
                final review = {
                  'rating': _rating,
                  'observation': _observationController.text,
                };
                provider.saveSatisfacaoToDatabase(review);
                print('Avaliação salva: $review');

                // Exemplo: Fechar a página após o envio
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: const Text('Enviar Avaliação'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }
}
