import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecaidaPage extends StatefulWidget {
  final Map<String, dynamic> vicio;
  final Map<String, dynamic> dadosUsuario;

  const RecaidaPage({
    super.key,
    required this.vicio,
    required this.dadosUsuario,
  });

  @override
  State<RecaidaPage> createState() => _RecaidaPageState();
}

class _RecaidaPageState extends State<RecaidaPage> {
  DateTime dataSelecionada = DateTime.now();
  final recaidaController = TextEditingController();
  final List<String> emojis = ['😢', '😞', '😐', '😊', '😁', '😡'];
  String? _emojiSelecionado;
  final metaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int recaidasTotal = 0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  "Registrar recaídas",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: "Vício: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: widget.vicio['nome'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Data: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yy').format(dataSelecionada),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => _selecionarData(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    child: Text("Escolher data"),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "O que aconteceu? (opcional)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                controller: recaidaController,
                maxLines: 8,
                maxLength: 200,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Como vc estava se sentindo?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                emojis.map((emoji) {
                  final selecionado = _emojiSelecionado == emoji;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _emojiSelecionado = emoji;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color:
                          selecionado
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        emoji,
                        style: const TextStyle(
                          fontSize: 24,
                        ), // reduzido para caber melhor
                      ),
                    ),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.track_changes),
                        SizedBox(width: 8),
                        Text("Defina sua nova meta (dias)"),
                      ],
                    ),
                    SizedBox(height: 2),
                    TextFormField(
                      controller: metaController,
                      decoration: InputDecoration(
                        hintText: "(Opcional)",
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.07,
                child: ElevatedButton(
                  onPressed: () => _registrarRecaida(recaidasTotal),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("REGISTRAR RECAÍDA"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selecionarData(BuildContext context) async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (data != null) {
      setState(() {
        dataSelecionada = data;
      });
    }
  }

  Future<void> _registrarRecaida(int recaidasTotal) async {
    final texto = recaidaController.text.trim();
    final uid = widget.dadosUsuario['uid'];
    final vicioId = widget.vicio['id'];

    final userRef = FirebaseFirestore.instance.collection('usuarios').doc(uid);
    final vicioRef = userRef.collection('vicios').doc(vicioId);

    try {
      // Verifica se o documento do vício existe
      final vicioSnapshot = await vicioRef.get();

      if (!vicioSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("O vício não existe mais. Por favor, tente novamente."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Buscar quantidade atual de recaídas
      final snapshot = await userRef.get();
      int atual = snapshot.data()?['recaidas_total'] ?? 0;
      atual++;

      // Validação da meta
      int? novaMeta;
      if (metaController.text.trim().isNotEmpty) {
        try {
          novaMeta = int.parse(metaController.text.trim());
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Meta inválida. Digite um número."),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
      }

      // Atualiza o vício com a nova recaída
      await vicioRef.set({
        'recaidas': FieldValue.arrayUnion([
          {
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'texto': texto,
            'sentimento': _emojiSelecionado,
            'data_inicio_abstinencia': widget.vicio['data_inicio'],
            'data_fim_abstinencia': dataSelecionada,
          },
        ]),
        'meta': novaMeta,
        'data_inicio_abstinencia': dataSelecionada,
      }, SetOptions(merge: true));

      // Atualiza contagem total
      await userRef.update({
        'recaidas_total': atual,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Recaída adicionada. Boa sorte!"),
          backgroundColor: Colors.red,
        ),
      );

      Navigator.of(context).pop();
      recaidaController.clear();
      metaController.clear();
      _emojiSelecionado = null;
    } catch (e) {
      print('Erro ao registrar recaída: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao registrar recaída. Tente novamente."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
