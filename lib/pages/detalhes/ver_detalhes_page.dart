import 'package:controlador_vicios/components/components.dart';
import 'package:controlador_vicios/pages/detalhes/recaida_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class VerDetalhesPage extends StatefulWidget {
  final Map<String, dynamic> vicio;
  final Map<String, dynamic> dadosUsuario;

  const VerDetalhesPage({
    super.key,
    required this.vicio,
    required this.dadosUsuario,
  });

  @override
  State<VerDetalhesPage> createState() => _VerDetalhesPageState();
}

class _VerDetalhesPageState extends State<VerDetalhesPage> {
  String mensagemProgresso = '';

  @override
  Widget build(BuildContext context) {
    final ultimaRecaida =
        (widget.vicio['recaidas'] is List &&
                widget.vicio['recaidas'].isNotEmpty)
            ? DateFormat('dd/MM/yyyy').format(
              (widget.vicio['recaidas'].last['data_fim_abstinencia']
                      as Timestamp)
                  .toDate(),
            )
            : 'Sem recaídas';

    final int diasLimpos = widget.vicio['dias_limpos'] ?? 0;
    final int meta = int.tryParse(widget.vicio['meta'].toString()) ?? 1;
    double progressoMeta = diasLimpos / meta;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Detalhes de: ${widget.vicio['nome']}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: calcularTamanhoFonte(widget.vicio['nome']),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dias limpos: ${widget.vicio['dias_limpos']}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Meta atual: ${widget.vicio['meta']}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Última recaída: $ultimaRecaida",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Progresso",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator(
                                value: progressoMeta.clamp(0.0, 1.0),
                                backgroundColor: appColors.secondary,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  appColors.primary,
                                ),
                                strokeWidth: 12,
                              ),
                            ),
                            Text(
                              '${(progressoMeta * 100).clamp(0, 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              mensagemProgressoWidget(progressoMeta),
                              TextButton(
                                onPressed:
                                    () => _navegarParaRecaida(widget.vicio),
                                child: Text(
                                  'Adicionar recaída',
                                  style: TextStyle(color: appColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Histórico de recaídas",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: ClampingScrollPhysics(),
                        itemCount: (widget.vicio['recaidas']?.length ?? 0) + 1,
                        itemBuilder: (context, index) {
                          final int total = widget.vicio['recaidas']?.length ?? 0;
          
                          if (index < total) {
                            final recaida = widget.vicio['recaidas'][index];
                            final data =
                                (recaida['data_fim_abstinencia'] as Timestamp)
                                    .toDate();
                            final sentimento = recaida['sentimento'] ?? "";
                            final texto =
                                (recaida['texto']?.toString().trim().isEmpty ??
                                        true)
                                    ? 'Sem descrição'
                                    : recaida['texto'];
          
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: appColors.primary,
                                  ),
                                  SizedBox(width: 5),
                                  Text(DateFormat('dd/MM/yy').format(data)),
                                  SizedBox(width: 5),
                                  Text("-"),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      texto,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text('-'),
                                  SizedBox(width: 5),
                                  Text(sentimento),
                                ],
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    '+ Adicionar nova recaída',
                                    style: TextStyle(color: appColors.primary),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Anotações pessoais",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: (widget.vicio['anotacao'].length) + 1,
                        itemBuilder: (context, index) {
                          final total = widget.vicio['anotacao'].length;
          
                          if (index < total) {
                            final anotacao =
                                widget
                                    .vicio['anotacao'][index]; // <-- erro estava aqui
                            final data = (anotacao['data'] as Timestamp).toDate();
                            final sentimento = anotacao['sentimento'] ?? "";
                            final texto =
                                (anotacao['texto']?.toString().trim().isEmpty ??
                                        true)
                                    ? 'Sem descrição'
                                    : anotacao['texto'];
          
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: appColors.primary,
                                  ),
                                  SizedBox(width: 5),
                                  Text("${DateFormat('dd/MM/yy').format(data)}:"),
                                  SizedBox(width: 5,),
                                  Text(texto, maxLines: 5, overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            );
                          }
                        },
                      ),
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

  Widget mensagemProgressoWidget(double progressoMeta) {
    if (progressoMeta >= 1.0) {
      return const Text(
        '🎉 Parabéns! Meta alcançada!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.green,
        ),
      );
    } else if (progressoMeta >= 0.75) {
      return const Text(
        '👏 Você está quase lá, continue assim!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.blue,
        ),
      );
    } else if (progressoMeta >= 0.5) {
      return const Text(
        '💪 Você já passou da metade!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.yellow,
        ),
      );
    } else if (progressoMeta > 0.0) {
      return const Text(
        '🚀 Começo promissor! Continue focado!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.orange,
        ),
      );
    } else {
      return const Text(
        '⏳ Ainda não começou, mas nunca é tarde!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.grey,
        ),
      );
    }
  }

  void _navegarParaRecaida(Map<String, dynamic> vicio) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                RecaidaPage(vicio: vicio, dadosUsuario: widget.dadosUsuario),
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
  }

  double calcularTamanhoFonte(String texto) {
    if (texto.length <= 15) return 25;
    if (texto.length <= 20) return 20;
    if (texto.length <= 30) return 18;
    return 10;
  }
}
