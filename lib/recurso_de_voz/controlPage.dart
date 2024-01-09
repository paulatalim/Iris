import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mqtt/state/MQTTAppState.dart';
import '../interfaces/menu.dart';

class ControlScreen extends StatefulWidget {
  ControlScreen({super.key, required this.index});
  int index;

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _irMenu(widget.index);
  }

  void _irMenu(int index) async {
    debugPrint(index.toString());
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
    _alterarUI(index);
  }

  void _alterarUI(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<MQTTAppState>(
          create: (_) => MQTTAppState(),
          child: Scaffold(
            appBar: AppBar(
              title: Text('Carregando'),
              backgroundColor: Colors.purple, // Cor lilás
            ),
            body: Container(
              color: Colors.purple, // Cor lilás
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Página'),
        backgroundColor: Colors.purple, // Cor lilás
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple), // Cor lilás
              ),
            )
          : Container(
              color: Colors.purple, // Cor lilás
              // Adicione o conteúdo da sua página aqui
            ),
    );
  }
}