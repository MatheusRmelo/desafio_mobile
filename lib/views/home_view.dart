import 'package:desafio_mobile/helpers/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: ElevatedButton(
        child: const Text("Sair"),
        onPressed: () {
          FirebaseAuth.instance.signOut().then((value) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.login, (route) => false);
          });
        },
      )),
    );
  }
}
