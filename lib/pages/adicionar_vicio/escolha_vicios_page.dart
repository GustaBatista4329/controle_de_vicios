import 'package:flutter/material.dart';

import 'adicionar_vicio_page.dart';

class EscolhaViciosPage extends StatefulWidget {
  final Map<String, dynamic> dadosUsuario;
  const EscolhaViciosPage({super.key, required this.dadosUsuario});

  @override
  State<EscolhaViciosPage> createState() => _EscolhaViciosPageState();
}

class _EscolhaViciosPageState extends State<EscolhaViciosPage> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> vicios = [
    {
      "nome": "🍺 Álcool",
      "descricao":
      "Substância comum no convívio social, pode se tornar um escape frequente em momentos difíceis.",
      "descricaoCompleta":
      """O álcool é uma das substâncias psicoativas mais consumidas no mundo, muitas vezes associado a
celebrações, relaxamento e vida social. Entretanto, quando o uso se torna frequente e descontrolado,
instala-se um padrão de dependência. Ele age no sistema nervoso central promovendo relaxamento,
desinibição e sensação de prazer ao aumentar a atividade de GABA e liberar dopamina. Com o tempo,
surgem tolerância e abstinência, além de riscos físicos como doenças hepáticas, pancreatite, câncer
e problemas cardíacos. Psicologicamente, pode levar à depressão, ansiedade e isolamento. Muitas
pessoas usam o álcool para lidar com estresse, traumas ou solidão. O tratamento exige empatia, apoio
multidisciplinar e conscientização da sociedade sobre o sofrimento envolvido.""",
    },
    {
      "nome": "🚬 Tabaco (nicotina)",
      "descricao":
      "Muitas vezes associado ao alívio da ansiedade, seu uso contínuo pode gerar forte dependência.",
      "descricaoCompleta":
      """A nicotina é uma das substâncias mais viciantes que existem. Seu efeito é rápido, atingindo o
cérebro em segundos após a inalação, onde ativa receptores de acetilcolina e libera dopamina,
gerando alívio e prazer. Com o uso contínuo, o cérebro se adapta e a dependência se instala. A
abstinência provoca irritabilidade, ansiedade e dificuldade de concentração. Fisicamente, o tabaco
está ligado a doenças cardíacas, pulmonares, AVC e diversos tipos de câncer. O ato de fumar
geralmente se associa a momentos de ansiedade, estresse ou hábito social. Abordagens terapêuticas
incluem medicamentos, suporte psicológico e empatia com o contexto emocional do fumante.""",
    },
    {
      "nome": "❄️ Cocaína e Crack",
      "descricao":
      "Drogas estimulantes que trazem sensação intensa de prazer, mas podem rapidamente fugir do controle.",
      "descricaoCompleta":
      """Cocaína e crack são estimulantes potentes do sistema nervoso central. Atuam impedindo a recaptação
de dopamina, serotonina e noradrenalina, o que gera euforia, energia e sensação de poder. No
entanto, essa ativação artificial danifica o cérebro com o tempo, causando depressão, paranoia,
anedonia (incapacidade de sentir prazer) e, em casos graves, psicose. O crack, por ser inalado, tem
efeito mais rápido e devastador. Ambos os vícios geram forte compulsão e risco elevado de infarto,
AVC e morte súbita. O consumo geralmente está associado a contextos de sofrimento profundo, e o
tratamento requer intervenção médica, apoio psicossocial e ausência de julgamento.""",
    },
    {
      "nome": "💉 Heroína (opioides em geral)",
      "descricao":
      "Busca por alívio físico ou emocional pode levar ao uso repetido de substâncias muito potentes.",
      "descricaoCompleta":
      """A heroína e outros opioides atuam nos receptores cerebrais responsáveis pelo prazer e alívio da dor.
Seu uso causa relaxamento intenso e euforia, o que os torna extremamente viciantes. Com o tempo, o
organismo desenvolve tolerância, e a interrupção leva à abstinência com dores intensas, náuseas,
agitação e insônia. A overdose é frequente e pode causar parada respiratória. Muitos casos começam
com opioides prescritos para dor. O vício em opioides é uma das crises de saúde pública mais graves,
como mostra a epidemia nos EUA. A recuperação envolve suporte médico, programas de substituição
(como metadona), psicoterapia e acompanhamento próximo.""",
    },
    {
      "nome": "💊 Medicamentos controlados",
      "descricao":
      "Remédios usados para ansiedade ou dor podem se tornar uma forma de lidar com o dia a dia.",
      "descricaoCompleta":
      """Benzodiazepínicos (como clonazepam e diazepam) e opioides prescritos são comumente usados para tratar
ansiedade, insônia e dor. Apesar da eficácia inicial, seu uso prolongado sem supervisão pode levar à
dependência física e psíquica. A pessoa desenvolve tolerância e pode se tornar emocionalmente
dependente do medicamento para funcionar. A abstinência desses remédios pode ser severa e requer
redução gradual sob orientação médica. O tratamento deve respeitar o histórico da pessoa, que muitas
vezes recorre a esses medicamentos como tentativa legítima de alívio do sofrimento. A escuta sem
julgamento é fundamental nesse processo.""",
    },
    {
      "nome": "🧪 Metanfetamina",
      "descricao":
      "Estimulante poderoso que pode ser buscado para dar energia ou foco, mas traz riscos importantes.",
      "descricaoCompleta":
      """A metanfetamina é uma droga sintética altamente viciante. Estimula a liberação massiva de dopamina,
provocando euforia, aumento de energia e foco. No entanto, com o uso contínuo, surgem alucinações,
paranoia, psicose e deterioração física severa. A droga danifica os neurônios dopaminérgicos,
podendo causar distúrbios cognitivos permanentes. É comum o usuário entrar em ciclos de uso seguidos
por colapsos físicos e emocionais. O uso pode estar associado a busca por desempenho, fuga emocional
ou contextos de exclusão. A recuperação é desafiadora e exige abordagem médica, psicossocial e
comunitária, com suporte constante.""",
    },
    {
      "nome": "🎰 Jogos de azar (ludopatia)",
      "descricao":
      "A emoção do jogo pode virar um hábito difícil de controlar, especialmente em momentos de estresse.",
      "descricaoCompleta":
      """A ludopatia é caracterizada pela prática compulsiva de jogos de azar, como apostas esportivas,
cassinos e jogos digitais. O cérebro responde ao jogo com liberação de dopamina, especialmente
durante ganhos ou quase-ganhos. Isso gera um ciclo viciante de risco e recompensa. Com o tempo, a
pessoa perde o controle sobre os gastos e o tempo dedicado ao jogo, levando a problemas financeiros,
familiares e emocionais. A abstinência pode causar ansiedade, irritabilidade e impulsividade. O
tratamento envolve terapia comportamental, grupos de apoio e estratégias para lidar com o impulso de
apostar. A empatia é essencial, pois o vício surge como forma de escapar de emoções difíceis.""",
    },
    {
      "nome": "🔞 Pornografia",
      "descricao":
      "O uso excessivo pode ser uma tentativa de lidar com solidão ou emoções difíceis.",
      "descricaoCompleta":
      """O consumo de pornografia em excesso pode ativar o sistema de recompensa cerebral de forma semelhante
às drogas. A repetição leva à dessensibilização, exigindo estímulos mais intensos para atingir o
mesmo nível de excitação. Isso pode gerar compulsão, dificuldades nas relações sexuais reais,
isolamento e sentimentos de culpa. A pornografia muitas vezes é usada como forma de aliviar solidão,
ansiedade ou frustração. A abordagem terapêutica deve ser livre de julgamentos, considerando o
contexto emocional do uso. O objetivo é promover autoconhecimento e desenvolver formas mais
saudáveis de lidar com emoções e sexualidade.""",
    },
    {
      "nome": "📱 Internet e redes sociais",
      "descricao":
      "Conexão constante pode servir como fuga para a ansiedade ou para a sensação de vazio.",
      "descricaoCompleta":
      """O uso excessivo de internet e redes sociais pode alterar o funcionamento cerebral, promovendo
dependência por estímulos constantes, curtidas e validação. O sistema dopaminérgico é ativado a cada
notificação ou comentário, reforçando o comportamento. Isso pode gerar insônia, dificuldade de
concentração, comparação constante, ansiedade e depressão. A abstinência causa irritação e sensação
de perda de conexão com o mundo. A dependência digital é comum, principalmente entre jovens, e deve
ser tratada com compreensão. A reeducação digital envolve redescobrir prazeres offline e estabelecer
limites saudáveis para o uso de tecnologia.""",
    },
    {
      "nome": "🌿 Maconha",
      "descricao":
      "Pode ser usada para relaxar ou se desligar, mas o uso frequente pode afetar o bem-estar.",
      "descricaoCompleta":
      """A maconha é frequentemente usada por seus efeitos relaxantes e por ajudar a 'desligar' da realidade.
No entanto, o uso crônico pode comprometer a memória, o foco, a motivação e, em jovens, o
desenvolvimento cerebral. Pode desencadear crises de ansiedade e, em pessoas predispostas, sintomas
psicóticos. Muitos recorrem à maconha como tentativa de aliviar insônia, dor ou sofrimento psíquico,
e isso precisa ser entendido com empatia. O problema não é o uso pontual, mas o padrão compulsivo e
diário que compromete o bem-estar. A abordagem ideal é centrada na redução de danos e suporte
psicoterapêutico individualizado.""",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: vicios.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("${vicios[index]['nome']}"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => AdicionarVicioPage(
                        vicio: vicios[index]['nome'],
                        descricaoVicio: vicios[index]['descricao'],
                        descricaoCompleta: vicios[index]['descricaoCompleta'],
                        dadosUsuario: widget.dadosUsuario,
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
