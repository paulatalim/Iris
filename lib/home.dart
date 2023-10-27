import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'configuracao.dart';
import 'sobre.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Color(0xFFbabdfa),
              Color(0xFFdba0ff),
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 230,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Positioned(
              top: 45,
              right: 16,
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.gear),
                    color: Colors.white,
                    iconSize: 30,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Configuracao()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.circleInfo),
                    color: Colors.white,
                    iconSize: 30,
                    onPressed: () {
                      (Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Sobre()),
                      ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
