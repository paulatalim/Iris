import 'package:flutter/material.dart';

import '../interfaces/menu.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key, required this.index});
  
  final int index;

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute( 
          builder: (context) => Menu(index: widget.index),
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

            body: Container(
              color: Colors.purple, // Cor lilás
              child: Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Carregando...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0), // Espaço entre o texto e o indicador de carregamento
                  CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                ],
              ),
            ),
            ),
          );
  }
}