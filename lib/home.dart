import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 200,
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
                  iconSize: 40,
                  onPressed: () {
                    // Ação do primeiro ícone
                  },
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.circleInfo),
                  color: Colors.white,
                  iconSize: 40,
                  onPressed: () {
                    // Ação do segundo ícone
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
