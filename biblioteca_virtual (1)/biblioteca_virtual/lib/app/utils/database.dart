import 'dart:developer';
import 'dart:typed_data';

import 'package:biblioteca_virtual/app/utils/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

void saveUser({
  required String name,
  required String email,
}) async {
  DocumentReference userDB =
      FirebaseFirestore.instance.collection('Users').doc(email);

  await userDB.get().then((DocumentSnapshot doc) async {
    if (doc.exists) {
      return await userDB.update({
        'name': name,
        'email': email,
      });
    } else {
      return await userDB.set({
        'name': name,
        'email': email,
      });
    }
  });
}

Future<bool> saveLivro(
    {required BuildContext context,
    required String name,
    required String link,
    required Uint8List photo}) async {
  try {
    CollectionReference bibliDB =
        FirebaseFirestore.instance.collection('Livros');
    Reference ref = FirebaseStorage.instance
        .ref("Capas/${DateTime.now().microsecondsSinceEpoch}");

    await ref.putData(photo);
    var photoUrl = await ref.getDownloadURL();

    await bibliDB.add(
      {
        "name": name,
        "link": link,
        "email": FirebaseAuth.instance.currentUser!.email,
        "photo": photoUrl,
      },
    );

    return true;
  } catch (e) {
    Message.showError(context, 'Erro ao cadastrar');
    return false;
  }
}

Future<DocumentSnapshot?> getUser([String? email]) async {
  DocumentReference userDB = FirebaseFirestore.instance
      .collection('Users')
      .doc(email ?? FirebaseAuth.instance.currentUser!.email);

  DocumentSnapshot userDoc = await userDB.get();
  if (userDoc.exists) {
    return userDoc;
  }
}

Future<List<QueryDocumentSnapshot>> getAllLivros() async {
  CollectionReference bibliDB = FirebaseFirestore.instance.collection('Livros');
  var list = await bibliDB
      .where(
        "email",
        // isNotEqualTo: FirebaseAuth.instance.currentUser!.email,
      )
      .get();
  return list.docs.toList();
}

Future<List<QueryDocumentSnapshot>> getMeusLivros() async {
  CollectionReference bibliDB = FirebaseFirestore.instance.collection('Livros');
  var list = await bibliDB
      .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .get();
  return list.docs.toList();
}

Future<bool> removerLivro(String id) async {
  CollectionReference bibliDB = FirebaseFirestore.instance.collection('Livros');
  try {
    var ref = await bibliDB.doc("$id");
    ref.delete();
    return true;
  } catch (e) {
    return false;
  }
}
