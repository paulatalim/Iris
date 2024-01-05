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
    return Container(
      color: Colors.transparent,
    ); 
  }
}