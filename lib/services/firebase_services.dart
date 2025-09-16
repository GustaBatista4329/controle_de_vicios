import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


Future<User?> cadastrarUsuarioCompleto({
  required String nome,
  required String sobrenome,
  required String email,
  required String senha,
}) async {
  try {

    UserCredential cred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: senha);

    User? user = cred.user;


    await user?.updateDisplayName('$nome $sobrenome');

    await FirebaseFirestore.instance.collection('usuarios').doc(user!.uid).set({
      'uid': user.uid,
      'nome': nome,
      'sobrenome': sobrenome,
      'email': email,
      'dias_limpos_geral': [],
      'data_cadastro': Timestamp.now(),
    });

    //await FirebaseFirestore.instance
        //.collection('usuarios')
        //.doc(user.uid)
        //.collection('vicios')
        //.doc('placeholder')
        //.set({'nome': 'placeholder', 'e-placeholder': true});

    return user;
  } catch (e) {
    //print('Erro no cadastro: $e');
    return null;
  }
}

Future<Map<String, dynamic>?> loginUsuario({
  required String email,
  required String senha,
}) async {
  try {
    // 1. Autentica o usuário
    UserCredential cred = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha);

    User? user = cred.user;

    if (user == null) return null;

    // 2. Busca os dados do Firestore
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get();

    if (snapshot.exists) {
      return snapshot.data(); // retorna os dados do perfil
    } else {
      //print('Usuário autenticado mas sem dados no Firestore');
      return null;
    }
  } catch (e) {
    //print('Erro no login: $e');
    return null;
  }
}

Future<void> adicionarVicio(String uid, String nomeVicio) async {
  await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(uid)
      .collection('vicios')
      .add({'nome': nomeVicio, 'criado_em': FieldValue.serverTimestamp()});
}

Future<void> adicionarDiaLimpo(
  String uid,
  String vicioId,
  DateTime data,
) async {
  await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(uid)
      .collection('vicios')
      .doc(vicioId)
      .collection('dias_limpos')
      .add({'data': Timestamp.fromDate(data)});
}

Future<void> logout(BuildContext context)async{
  await FirebaseAuth.instance.signOut();
  Navigator.of(context).pushReplacementNamed('/login');
}

