import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFEEF8F7),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                'ISE',
                style: TextStyle(
                  color: Color.fromRGBO(67, 136, 131, 1.0),
                  fontSize: 60,
                ),
              ),
              Text(
                'Instituto de Saúde Especializado',
                style: TextStyle(
                  color: Color.fromRGBO(67, 136, 131, 1.0),
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
