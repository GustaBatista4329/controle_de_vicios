import 'package:controlador_vicios/components/components.dart';
import 'package:controlador_vicios/services/firebase_services.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
        centerTitle: true,
        backgroundColor: appColors.primary,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite seu nome";
                  }
                },
              ),
              TextFormField(
                controller: _sobrenomeController,
                decoration: InputDecoration(labelText: "Sobrenome"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite seu sobrenome";
                  }
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "E-mail"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite um email!";
                  }
                  if (!value.contains('@')) {
                    return "Digite um email valido!";
                  }
                },
              ),
              TextFormField(
                controller: _senhaController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: "Senha",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.length < 6) {
                    return 'A Senha deve ter pelo menos 6 digitos!';
                  }
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    try{
                    if (_formKey.currentState!.validate()) {
                      final user = await cadastrarUsuarioCompleto(
                        nome: _nomeController.text,
                        sobrenome: _sobrenomeController.text,
                        email: _emailController.text,
                        senha: _senhaController.text,
                      );

                      if (user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Cadastro realizado com sucesso!")),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Erro ao cadastrar")),
                        );
                      }
                    }
                  } catch(e){
                      print("print $e");
                    }
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.primary,
                  foregroundColor: Colors.black,
                ),
                child: Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
