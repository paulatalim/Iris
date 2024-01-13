import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mqtt/state/MQTTAppState.dart';
import '../interfaces/menu.dart';


import '../recurso_de_voz/controlPage.dart';
import '../recurso_de_voz/voices.dart';
import '../storage/usuario.dart';


//StatefulWidget índice como parâmetro.
class ControlScreen extends StatefulWidget {
  ControlScreen({super.key, required this.index});
  int index;
  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

//Estado de carregamento 
class _ControlScreenState extends State<ControlScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _irMenu(widget.index);
  }

  //Metodo para esperar 2 segundos e definir Isloading como falso
  void _irMenu(int index) async {
    debugPrint(index.toString());
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
    _alterarUI(index);
  }

  //Metodo para mudar a tela de acordo com o index
  void _alterarUI(int index) {

    voice.speek("Carregando, aguarde!"); //Voz carregando 

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<MQTTAppState>(
          create: (_) => MQTTAppState(),

          //Scaffold
          child: Scaffold(

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
          ),
        ),
      ),
    );
  }

  //Metodo para retornar o scaffold criado com base no estado de Isloading
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple), // Cor lilás
              ),
            )
          : Container(
              color: Colors.purple, // Cor lilás
            ),
    );
  }
}