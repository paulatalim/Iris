import 'package:flutter/material.dart';
import './interfaces/menu.dart';

class ControlScreen extends StatefulWidget {
  int index;

  ControlScreen({required int index}): this.index = index;

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  void irMenu(int index) async {
    print(index);
    await Future.delayed(Duration(seconds: 5));
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Menu(index: index,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    irMenu(widget.index);
    return Container(
      color: Colors.transparent,
    ); 
  }
}