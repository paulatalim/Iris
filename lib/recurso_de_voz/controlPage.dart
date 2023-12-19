import 'package:flutter/material.dart';

import '../interfaces/menu.dart';

//ignore: must_be_immutable
class ControlScreen extends StatefulWidget {
  ControlScreen({super.key, required this.index});
  int index;

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  void _irMenu(int index) async {
    debugPrint(index.toString());
    await Future.delayed(const Duration(seconds: 2));
    _alterarUI(index);
  }

  void _alterarUI(int index) {
    Navigator.push(
      context,
      MaterialPageRoute( 
        builder: (context) => Menu(index: index),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    _irMenu(widget.index);
    return Container(
      color: Colors.transparent,
    ); 
  }
}