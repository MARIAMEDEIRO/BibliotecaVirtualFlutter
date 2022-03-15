import 'package:biblioteca_virtual/app/screens/cadastro/cadastro.dart';
import 'package:biblioteca_virtual/app/screens/home/home.dart';
import 'package:biblioteca_virtual/app/screens/meus_livros/meus_livros.dart';
import 'package:biblioteca_virtual/app/utils/remove_scrollglow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/login/login.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: BehaviorRemoveScrollGlow(),
      home: FirebaseAuth.instance.currentUser != null
          ? HomeScreen()
          : LoginScreen(),
    );
  }
}
