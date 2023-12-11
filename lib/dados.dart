import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:typed_data/typed_buffers.dart' show Uint8Buffer;
import 'dart:async';
import 'dart:convert';

import 'usuario.dart';
import './hardware1.dart';

class Dados extends StatefulWidget {
  const Dados({super.key});

  @override
  State<Dados> createState() => _DadosState();
}

class _DadosState extends State<Dados> {
  MqttHandler mqttHandler = MqttHandler();

  double temperatura = -2;
  double _temp = -10;
  double soma = 0;

 
  // void initState() {
  //   super.initState();
  //   mqttHandler.connect();
  // }
  String broker = 'test.mosquitto.org';
    int port = 1883;
    String clientIdentifier = 'LDDM_Iris';
    String topic = 'iris/sensor/temperatura';
    late StreamSubscription subscription;    
   late mqtt.MqttClient client;
    late mqtt.MqttConnectionState connectionState;


 @override
   void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _connect());
  }

  /*
  Assina o tópico onde virão os dados de temperatura
   */
  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
        print('[MQTT client] Subscribing to ${topic.trim()}');
        client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
    }
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
// void temp () {
//       print("oi");
      
//       if (mqttHandler.data.value.isEmpty) {
        
//         temperatura = "-5";
//       }
//       temperatura =  mqttHandler.data.value;
//     }

  @override
  Widget build(BuildContext context) {
    

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
                '', _temp.toString(), '°'),
            boxNumber('IMC', usuario.imc.toStringAsFixed(1), ''),
            GestureDetector(
              onTap: () { 
                setState(() {
                  if (mqttHandler.data.compareTo("") == 0) {
        soma ++;
                      temperatura = soma;
                      print("valor: " + mqttHandler.data);
                    } else {
                      print("valor: " + mqttHandler.data);
                      // temperatura = double.parse(mqttHandler.data.value);
                    }
                });
              },
              child: Container(width: 100, height: 200, color: Colors.red,),
            )
          ],
        ),
      ),
    );
    
  }
  /*
  Conecta no servidor MQTT à partir dos dados configurados nos atributos desta classe (broker, port, etc...)
   */
  void _connect() async {
    client = mqtt.MqttClient(broker, '');
    client.port = port;
    client.keepAlivePeriod = 30;
    client.onDisconnected = _onDisconnected;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        .withWillQos(mqtt.MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print(e);
      _disconnect();
    }

    /// Check if we are connected
    if (client.connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] connected');
      setState(() {
        connectionState = client.connectionState!;
      });
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionState}');
      _disconnect();
    }

    client.updates?.listen(_onMessage);
    _subscribeToTopic(topic);
  }

  /*
  Desconecta do servidor MQTT
   */
  void _disconnect() {
    print('[MQTT client] _disconnect()');
    client.disconnect();
    _onDisconnected();
  }

  /*
  Executa algo quando desconectado, no caso, zera as variáveis e imprime msg no console
   */
  void _onDisconnected() {
    print('[MQTT client] _onDisconnected');
    setState(() {
      //topics.clear();
      connectionState = client.connectionState!;
      // client = null;
      // subscription.cancel();
      // subscription = null;
      // subscription = null;
    });
    print('[MQTT client] MQTT client disconnected');
  }


    /*
  Escuta quando mensagens são escritas no tópico. É aqui que lê os dados do servidor MQTT e modifica o valor do termômetro
   */
  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    print(event.length);
    final mqtt.MqttPublishMessage recMess =
    event[0].payload as mqtt.MqttPublishMessage;
    final String message =
    mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    print('[MQTT client] MQTT message: topic is <${event[0].topic}>, ''payload is <-- ${message} -->');
    print(client.connectionState);
    print("[MQTT client] message with topic: ${event[0].topic}");
    print("[MQTT client] message with message: ${message}");
    setState(() {
      _temp = double.parse(message);
    });
  }
}
