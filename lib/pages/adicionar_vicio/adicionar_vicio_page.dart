import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';

class AdicionarVicioPage extends StatefulWidget {
  final String vicio;
  final String descricaoVicio;
  final String descricaoCompleta;
  final Map<String, dynamic> dadosUsuario;

  const AdicionarVicioPage({
    super.key,
    required this.vicio,
    required this.descricaoVicio,
    required this.descricaoCompleta,
    required this.dadosUsuario,
  });

  @override
  State<AdicionarVicioPage> createState() => _AdicionarVicioPageState();
}

class _AdicionarVicioPageState extends State<AdicionarVicioPage> {
  bool descricao_completa = false;
  DateTime? _dataSelecionada;
  final metaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(widget.vicio, style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.5),),
              AnimatedSize(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: AnimatedContainer(
                  margin: const EdgeInsets.only(top: 40),
                  transform: Matrix4.identity()..translate(0.0, -30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 10),
                        blurRadius: 20,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 10),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description),
                          SizedBox(width: 8),
                          Text(
                            "Descrição da dependência",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        descricao_completa
                            ? widget.descricaoCompleta
                            : widget.descricaoVicio,
                        style: TextStyle(fontSize: 15),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            descricao_completa = !descricao_completa;
                          });
                        },
                        icon: Icon(
                          descricao_completa ? Icons.remove : Icons.add,
                        ),
                        color: descricao_completa ? Colors.red : Colors.green,
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 40),
                transform: Matrix4.identity()..translate(0.0, -30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(0, 10),
                      blurRadius: 20,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () => _selecionarData(context),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.calendar_month, color: Colors.blueGrey),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data de início dos dias limpos',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey.shade900,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              _dataSelecionada != null
                                  ? 'Selecionado: ${_dataSelecionada!.day.toString().padLeft(2, '0')}/'
                                      '${_dataSelecionada!.month.toString().padLeft(2, '0')}/'
                                      '${_dataSelecionada!.year}'
                                  : 'Selecione a data de inicio',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    _dataSelecionada != null
                                        ? Colors.blueGrey.shade800
                                        : Colors.blueGrey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40),
                transform: Matrix4.identity()..translate(0.0, -30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(0, 10),
                      blurRadius: 20,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.track_changes),
                          SizedBox(width: 8),
                          Text("Defina sua meta (dias)"),
                        ],
                      ),
                      SizedBox(height: 2,),
                      TextFormField(
                        controller: metaController,
                        decoration: InputDecoration(hintText: "(Opcional)", border: InputBorder.none),
                      )
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.primary,
                  foregroundColor: appColors.secondary,
                  iconColor: appColors.secondary,
                ),
                onPressed: adicionarVicio,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    Text(
                      "Adicionar dependencia",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calcularTamanhoFonte(String texto) {
    if (texto.length <= 15) return 25;
    if (texto.length <= 20) return 20;
    if (texto.length <= 30) return 18;
    return 10;
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
        _dataSelecionada = data;
      });
    }
  }

  int _tempoLimpo(DateTime dataInicial) {
    if (_dataSelecionada == null) return 0;
    DateTime hoje = DateTime.now();

    int dias = hoje.difference(dataInicial).inDays;

    return dias;
  }

  Future<void> adicionarVicio() async {
    if (_dataSelecionada == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Selecione a data de inicio")));
    }

    final int dias = _tempoLimpo(_dataSelecionada!);

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(widget.dadosUsuario['uid'])
        .collection('vicios')
        .add({
          'nome': widget.vicio,
          'criado_em': FieldValue.serverTimestamp(),
          'data_inicio': Timestamp.fromDate(_dataSelecionada!),
          'dias_limpos': [],
          'meta': '${int.parse(metaController.text)}',
          'recaidas': [],
          'anotacao': []
        });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Vício '${widget.vicio}' adicionado com sucesso!"),
      ),
    );

    Navigator.pop(context);
    Navigator.pop(context);
  }
}
