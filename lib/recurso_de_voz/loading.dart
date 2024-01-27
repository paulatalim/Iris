import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        // color: Colors.purple,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Color.fromARGB(255, 129, 135, 248),
              Color.fromARGB(255, 189, 94, 248),
            ],
          ),
        ),
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Carregando...',
              style: GoogleFonts.inclusiveSans(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            // Espaço entre o texto e o indicador de carregamento
            SizedBox(height: 50.0), 
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