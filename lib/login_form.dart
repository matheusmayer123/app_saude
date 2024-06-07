import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import 'package:app_saude/providers/user_provider.dart';
import 'package:app_saude/pages/home_page.dart';
import 'package:app_saude/pages/registerpage.dart';
import 'package:app_saude/pages/registerpage_medico.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var controllerCPF = MaskedTextController(mask: '000.000.000-00');
  TextEditingController controllerPassword = TextEditingController();

  void _login(UserProvider userProvider) async {
    String cpf = controllerCPF.text;
    String password = controllerPassword.text;

    
    String result = await userProvider.authenticateUser(cpf, password);

    
    if (result == 'Autenticação bem-sucedida') {
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            SizedBox(height: 10),
            TextField(
              controller: controllerCPF,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'CPF'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: controllerPassword,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Esqueceu sua senha?',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                    width: 350,
                    child: TextButton(
                      onPressed: () => _login(userProvider),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(62, 124, 120, 1.0),
                        ),
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextButton(
                    onPressed: () {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: const Text(
                      'Cadastre-se aqui!',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPageMedico()),
                      );
                    },
                    child: const Text(
                      'Cadastre-se aqui Médico',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
