import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controlador_vicios/components/components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdicionarAnotacaoPage extends StatefulWidget {
  final Map<String, dynamic> vicio;
  final Map<String, dynamic> dadosUsuario;

  const AdicionarAnotacaoPage({
    super.key,
    required this.vicio,
    required this.dadosUsuario,
  });

  @override
  State<AdicionarAnotacaoPage> createState() => _AdicionarAnotacaoPageState();
}

class _AdicionarAnotacaoPageState extends State<AdicionarAnotacaoPage> {
  final List<String> emojis = ['😢', '😞', '😐', '😊', '😁','😡'];
  String? emojiSelecionado;

  final anotacaoController = TextEditingController();

  String hoje = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Vício: ",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 24,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          widget.vicio['nome'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Dias limpos: ",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      widget.vicio['dias_limpos'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
          Row(
            children: [
              Text(
                "Última anotação: ",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              ),
              Text(
                (widget.vicio['anotacao'] is List &&
                    widget.vicio['anotacao'].isNotEmpty)
                    ? DateFormat('dd/MM/yyyy').format(
                  (widget.vicio['anotacao'].last['data'] as Timestamp).toDate(),
                )
                    : 'Sem anotações',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ],
          ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(10),
                width: 170,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 27),
                    SizedBox(width: 5),
                    Text(
                      hoje,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: emojis.map((emoji) {
              final selecionado = emojiSelecionado == emoji;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    emojiSelecionado = emoji;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: selecionado ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 24), // reduzido para caber melhor
                  ),
                ),
              );
            }).toList(),
          ),
            SizedBox(height: 20),
            TextFormField(
              controller: anotacaoController,
              maxLines: 8,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: 'Escreva sua anotação aqui',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _adicionarAnotacao,
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text("Adicionar anotação"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _adicionarAnotacao() async {
    final texto = anotacaoController.text.trim();

    if (texto.isEmpty || emojiSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Preencha a anotação e selecione um emoji."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(widget.dadosUsuario['uid'])
        .collection('vicios')
        .doc(widget.vicio['id'])
        .update({
          'anotacao': FieldValue.arrayUnion([
            {
              'texto': texto,
              'sentimento': emojiSelecionado,
              'data': Timestamp.now(),
            },
          ]),
        });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Anotação adicionada com sucesso."),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }
}
