import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './hardware/mqtt/MQTTManager.dart';
import './hardware/mqtt/state/MQTTAppState.dart';
import 'usuario.dart';


class Dados extends StatefulWidget {
  const Dados({super.key});

  @override
  State<Dados> createState() => _DadosState();
}

class _DadosState extends State<Dados> {
  late MQTTAppState currentAppState;
  late MQTTManager manager;

  @override
  void initState() {
    super.initState();
  }

  Container boxNumber(String texto, String numero, String unidade) {
    return Container(
      // margin: EdgeInsets.all(30.0), //Espaço entre as caixinhas
      height: 80.0, // Defina a altura desejada, por exemplo, 100.0 pixels
      width: 0.8 * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xFFdadcff),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(90, 0, 0, 0),
              blurRadius: 10,
              offset: Offset(5, 5)),
          BoxShadow(
              color: Color.fromARGB(200, 255, 255, 255),
              blurRadius: 13,
              offset: Offset(-5, -5)),
        ],
      ),
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Alinha texto e número na mesma linha
        children: <Widget>[
          Text(
            texto, // Exemplo de formatação com 2 casas decimais
            style: GoogleFonts.inclusiveSans(
              textStyle: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF373B8A),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                numero, // Exemplo de formatação com 2 casas decimais
                style: GoogleFonts.inclusiveSans(
                  textStyle: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF373B8A),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                unidade, // Exemplo de formatação com 2 casas decimais
                style: GoogleFonts.inclusiveSans(
                  textStyle: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF373B8A),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
    if(currentAppState.getAppConnectionState == MQTTAppConnectionState.disconnected) {
        _configureAndConnect();
                
    } else {
      switch (currentAppState.getReceivedText.trim()[0]) {
        case 'T':
          usuario.temperatura = double.parse(currentAppState.getReceivedText.substring(1));
          break;
        case 'A':
          usuario.altura = double.parse(currentAppState.getReceivedText.substring(1));
          usuario.calcular_imc();
          break;
        case 'P':
          usuario.peso = double.parse(currentAppState.getReceivedText.substring(1));
          usuario.calcular_imc();
          break;
      }
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
          // Container(
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     // Where the linear gradient begins and ends
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,

          //     colors: [
          //       Color(0xFFDFE0FB),
          //       Color(0xFFECCCFF),
          //     ],
          //   ),
          // ),
          // child:
          Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            boxNumber('Peso ', usuario.peso.toStringAsFixed(1), 'Kg'),
            boxNumber('Altura', usuario.altura.toStringAsFixed(2), 'm'),
            boxNumber(
                'Temperatura', usuario.temperatura.toStringAsFixed(1), '°'),
            boxNumber('IMC', usuario.imc.toStringAsFixed(1), ''),
            GestureDetector(
              onTap: currentAppState.getAppConnectionState == MQTTAppConnectionState.disconnected
                ? _configureAndConnect
                : null,
              child: Container(width: 100, height: 200, color: Colors.red,),
            )
          ],
        ),
      ),
    );
    
  }


  void _configureAndConnect() {
    // ignore: flutter_style_todos
    // TODO: Use UUID
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    manager = MQTTManager(
        host: 'test.mosquitto.org',
        topic: 'iris/sensor',
        identifier: osPrefix,
        state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();
  }
}
