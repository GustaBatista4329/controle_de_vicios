import 'package:controlador_vicios/pages/auth/cadastro_page.dart';
import 'package:controlador_vicios/pages/home_page.dart';
import 'package:controlador_vicios/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/components.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _obscureText = true;
  bool lembreSe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.only(top: 10),
              transform: Matrix4.identity()..translate(0.0, -30.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0, 10),
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Digite seu e-mail";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "E-mail",
                            floatingLabelStyle: TextStyle(
                              color: appColors.primary,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _senhaController,
                          obscureText: _obscureText,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Digite sua senha";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Senha",
                            floatingLabelStyle: TextStyle(color: appColors.primary),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CadastroPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Cadastre-se",
                                style: TextStyle(
                                  color: Colors.indigoAccent,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.indigoAccent,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _login(lembreSe),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigoAccent,
                                foregroundColor: Colors.black,
                              ),
                              child: Text("Entrar"),
                            ),
                          ],
                        ),
                        CheckboxListTile(
                          title: Text('Lembre-se de mim'),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          value: lembreSe,
                          onChanged: (valor) {
                            setState(() {
                              lembreSe = valor!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login(bool lembrar) async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    lembreSe = lembrar;

    final dadosUsuario = await loginUsuario(email: email, senha: senha);

    if (dadosUsuario != null) {
      if (lembrar) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('lembre_se', true);
      }
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  HomePage(dadosUsuario: dadosUsuario),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("erro")));
    }

    print("DADOS DO USUÁRIO LOGADO: $dadosUsuario");
  }
}
