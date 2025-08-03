import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controlador_vicios/components/components.dart';
import 'package:controlador_vicios/pages/adicionar_vicio/escolha_vicios_page.dart';
import 'package:controlador_vicios/pages/detalhes/adicionar_anotacao_page.dart';
import 'package:controlador_vicios/pages/detalhes/recaida_page.dart';
import 'package:controlador_vicios/pages/detalhes/ver_detalhes_page.dart';
import 'package:controlador_vicios/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> dadosUsuario;

  const HomePage({super.key, required this.dadosUsuario});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _viciosFuture;
  late Future<Map<String, dynamic>> _dadosUsuarioFuture;

  final GlobalKey _key = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viciosFuture = buscarVicios();
    _dadosUsuarioFuture = buscarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;
    double sizeIcons = 35;
    final nomeUsuario = widget.dadosUsuario['nome'] ?? "sem nome";
    final sobrenomeUsuario =
        widget.dadosUsuario['sobrenome'] ?? "sem sobrenome";
    final emailUsuario = widget.dadosUsuario['email'];

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    width: largura * 0.25,
                    height: altura * 0.25,
                    child: ClipOval(
                      child:
                          (widget.dadosUsuario['foto_url'] == null ||
                                  widget.dadosUsuario['foto_url']
                                      .toString()
                                      .trim()
                                      .isEmpty)
                              ? Icon(Icons.person, size: 90)
                              : Image.network(
                                widget.dadosUsuario['foto_url'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/perfil_padrao.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$nomeUsuario $sobrenomeUsuario",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        emailUsuario,
                        style: TextStyle(fontSize: largura * 0.030),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart_outlined, size: sizeIcons),
              title: Text(
                'Meu Progresso',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.edit_outlined, size: sizeIcons),
              title: Text(
                'Anotações',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              leading: Icon(Icons.show_chart, size: sizeIcons),
              title: Text(
                'Estatísticas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_outline, size: sizeIcons),
              title: Text(
                'Meu Perfil',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings_outlined, size: sizeIcons),
              title: Text(
                'Configurações',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, size: sizeIcons),
              title: Text(
                'Sair da conta',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      height: altura * 0.25,
                      width: largura * 1,
                      child: Column(
                        children: [
                          Text(
                            "Tem certeza que deseja sair?",
                            style: TextStyle(
                              fontSize: largura * 0.055,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Ao encerrar a sessão atual será preciso fazer login novamente",
                            style: TextStyle(fontSize: largura * 0.045),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                ),
                                child: Text("Cancelar"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  logout(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text("Sair"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Builder(
                builder:
                    (context) => IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(Icons.menu),
                    ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _viciosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text("Erro ao carregar dados."));
                  }

                  final vicios = snapshot.data ?? [];

                  if (vicios.isEmpty) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: _NavegarParaEscolhaViciosPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColors.primary,
                          foregroundColor: appColors.secondary,
                          iconColor: appColors.secondary,
                        ),
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
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              _viciosFuture = buscarVicios();
                            });
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  height: altura * 0.15,
                                  width: largura * 0.9,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Resumo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text("⚠️ Recaídas"),
                                              Text(widget.dadosUsuario['recaidas_geral'])
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    final vicio = vicios[index];
                                    final int diasLimpos = vicio['dias_limpos'] ?? 0;
                                    final int meta =
                                        int.tryParse(vicio['meta'].toString()) ?? 1;
                                    double progressoMeta = diasLimpos / meta;

                                    final ultimaRecaida =
                                        (vicio['recaidas'] is List &&
                                                vicio['recaidas'].isNotEmpty)
                                            ? DateFormat('dd/MM/yyyy').format(
                                              (vicio['recaidas']
                                                          .last['data_fim_abstinencia']
                                                      as Timestamp)
                                                  .toDate(),
                                            )
                                            : 'Sem recaídas';
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        width: largura * 0.9,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: ListTile(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  vicio['nome'],
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuButton<String>(
                                                icon: const Icon(Icons.more_vert),
                                                onSelected: (String value) {
                                                  if (value == 'recaida') {
                                                    return _navegarParaRecaida(vicio);
                                                  } else if (value == 'excluir') {
                                                    _excluirVicio(vicio);
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                        <PopupMenuEntry<String>>[
                                                          const PopupMenuItem<String>(
                                                            value: 'recaida',
                                                            child: Text('Recaída'),
                                                          ),
                                                          const PopupMenuItem<String>(
                                                            value: 'excluir',
                                                            child: Text(
                                                              'Excluir',
                                                              style: TextStyle(
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                              ),
                                            ],
                                          ),
                                          subtitle: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Dias Limpos: ",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${DateTime.now().difference(vicio['data_inicio_abstinencia'] != null ? (vicio['data_inicio_abstinencia'] as Timestamp).toDate() : (vicio['data_inicio'] as Timestamp).toDate()).inDays} dias",
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Meta: ",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(vicio['meta'].toString()),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Ultima recaída: ",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(ultimaRecaida),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Última anotação: ",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      (vicio['anotacao'] is List &&
                                                              vicio['anotacao']
                                                                  .isNotEmpty)
                                                          ? vicio['anotacao']
                                                              .last['texto']
                                                              .toString()
                                                          : 'Sem anotações',
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              Stack(
                                                alignment: Alignment.centerRight,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    child: LinearProgressIndicator(
                                                      value: progressoMeta.clamp(
                                                        0.0,
                                                        1.0,
                                                      ),
                                                      backgroundColor:
                                                          appColors.secondary,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(appColors.primary),
                                                      minHeight: 24,
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
                                              SizedBox(height: 4),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  OutlinedButton(
                                                    onPressed:
                                                        () => _navegarParaVerDetalhes(
                                                          vicio,
                                                        ),
                                                    style: OutlinedButton.styleFrom(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      side: BorderSide(
                                                        color: appColors.secondary,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "Ver detalhes",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  OutlinedButton(
                                                    onPressed:
                                                        () =>
                                                            _navegarParaAdicionarAnotacao(
                                                              vicio,
                                                            ),
                                                    style: OutlinedButton.styleFrom(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      side: BorderSide(
                                                        color: appColors.secondary,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Adicionar anotação',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: vicios.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: _NavegarParaEscolhaViciosPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColors.primary,
                            foregroundColor: appColors.secondary,
                            iconColor: appColors.secondary,
                          ),
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
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> buscarVicios() async {
    final uid = widget.dadosUsuario['uid'];
    final viciosSnapshot =
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .collection('vicios')
            .get();

    final List<Map<String, dynamic>> vicios = [];

    for (var doc in viciosSnapshot.docs) {
      final data = doc.data();

      // 🔹 1. Convertemos a data de início
      DateTime dataInicio;
      if (data['recaidas'] != null && (data['recaidas'] as List).isNotEmpty) {
        // Pega a última recaída
        final ultimaRecaida = (data['recaidas'] as List).last;
        dataInicio =
            (ultimaRecaida['data_fim_abstinencia'] as Timestamp).toDate();
      } else {
        dataInicio = (data['data_inicio'] as Timestamp).toDate();
      }

      int diasLimpos = DateTime.now().difference(dataInicio).inDays;

      // 🔹 3. Atualizamos no Firebase
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('vicios')
          .doc(doc.id)
          .update({'dias_limpos': diasLimpos});

      // 🔹 4. Adicionamos ao retorno local
      vicios.add({'id': doc.id, ...data, 'dias_limpos': diasLimpos});
    }

    return vicios;
  }

  Future<Map<String, dynamic>> buscarDadosUsuario() async {
    final uid = widget.dadosUsuario['uid'];
    final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
    return doc.data() ?? {};
  }


  void _NavegarParaEscolhaViciosPage() async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                EscolhaViciosPage(dadosUsuario: widget.dadosUsuario),
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

    // Quando voltar, recarrega os dados
    setState(() {
      _viciosFuture = buscarVicios();
    });
  }

  void _navegarParaAdicionarAnotacao(Map<String, dynamic> vicio) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder:
            (contex, animation, secondaryAnimation) => AdicionarAnotacaoPage(
              vicio: vicio,
              dadosUsuario: widget.dadosUsuario,
            ),
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
    setState(() {
      _viciosFuture = buscarVicios();
    });
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

    setState(() {
      _viciosFuture = buscarVicios();
    });
  }

  void _navegarParaVerDetalhes(Map<String, dynamic> vicio) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder:
            (context, animation, secondaryAnimation) => VerDetalhesPage(
              vicio: vicio,
              dadosUsuario: widget.dadosUsuario,
            ),
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

    setState(() {
      _viciosFuture = buscarVicios();
    });
  }

  Future<void> _excluirVicio(Map<String, dynamic> vicio) async {
    final uid = widget.dadosUsuario['uid'];
    final docId = vicio['id'];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Tem certeza que deseja excluir?'),
            content: Text('Essa ação não poderá ser desfeita.'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(
                    context,
                  ).pop(); // Fecha o diálogo antes de excluir
                  try {
                    await FirebaseFirestore.instance
                        .collection('usuarios')
                        .doc(uid)
                        .collection('vicios')
                        .doc(docId)
                        .delete();

                    setState(() {
                      _viciosFuture = buscarVicios();
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Vício excluído com sucesso.')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao excluir vício: $e')),
                    );
                  }
                },
                child: Text("Excluir", style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancelar"),
              ),
            ],
          ),
    );
  }

  // Future<void> _listaDiasLimposGeral() async{
  //   FirebaseFirestore.instance.collection('usuarios').doc('uid').update(
  //     {
  //       'dias_limpos_geral':
  //     }
  //   );
  // }
}
