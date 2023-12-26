import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../interfaces/login.dart';
import '../interfaces/menu.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        } else if (snapshot.hasError){
          return const Center(child: Text('Algo deu errado! Tente novamente mais tarde.'),);
        }

        // Verifica se usuario está logado
        if (snapshot.hasData) { 
          return const Menu(index: 0);
        } else {
          return const UserLogin();
        }
      },
    )
  );
}