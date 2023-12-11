// import 'package:iris_app/usuario.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// // import 'armazenamento.dart';
// import './usuario.dart';

// class MqttHelper {
//   late MqttServerClient mqttClient;
//   final String mqttTopic = 'iris/atuador/temperatura';
//   final String topicSystem = 'iris/atuador/sistema';
//   final String topicTemperatura = 'iris/atuador/temperatura';
//   final String topicAltura = 'iris/atuador/altura';
//   final String topicPeso = 'iris/atuador/peso';

//   Future<void> initMqtt() async {
//     mqttClient = MqttServerClient.withPort('test.mosquitto.org', 'iris_mqtt', 1883);
//     // mqttClient.port = 1883;
//     // mqttClient.logging(on: true);
    
//     // mqttClient.onConnected = _onMqttConnected;
//     // mqttClient.onDisconnected = _onMqttDisconnected;
//     // mqttClient.pongCallback = _onMqttPong;

//     // await _connectToMqtt();

//     mqttClient.logging(on: true);
//     mqttClient.onConnected = onConnected;
//     mqttClient.onDisconnected = onDisconnected;
//     mqttClient.onUnsubscribed = onUnsubscribed;
//     mqttClient.onSubscribed = onSubscribed;
//     mqttClient.onSubscribeFail = onSubscribeFail;
//     mqttClient.pongCallback = pong;
//     mqttClient.keepAlivePeriod = 60;
//     mqttClient.logging(on: true);
//     mqttClient.setProtocolV311();
//   }

//   void onConnected() async {
//   final connMessage = MqttConnectMessage()
//         .withWillTopic('willtopic')
//         .withWillMessage('Will message')
//         .startClean()
//         .withWillQos(MqttQos.atLeastOnce);

//     print('MQTT_LOGS::Mosquitto client connecting....');

//     mqttClient.connectionMessage = connMessage;
//     try {
//       await mqttClient.connect();
//     } catch (e) {
//       print('Exception: $e');
//       mqttClient.disconnect();
//     }

//     if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
//       print('MQTT_LOGS::Mosquitto mqttClient connected');
//     } else {
//       print(
//           'MQTT_LOGS::ERROR Mosquitto mqttClient connection failed - disconnecting, status is ${mqttClient.connectionStatus}');
//       mqttClient.disconnect();
//     }
// }

// void onDisconnected() {
//   print('MQTT_LOGS:: Disconnected');
// }

// void onSubscribed(String topic) {
//   print('MQTT_LOGS:: Subscribed topic: $topic');
// }

// void onSubscribeFail(String topic) {
//   print('MQTT_LOGS:: Failed to subscribe $topic');
// }

// void onUnsubscribed(String? topic) {
//   print('MQTT_LOGS:: Unsubscribed topic: $topic');
// }

// void pong() {
//   print('MQTT_LOGS:: Ping response client callback invoked');
// }

//   // Future<void> _connectToMqtt() async {
//   //   try {
//   //     await mqttClient.connect();
//   //     mqttClient.subscribe(mqttTopic, MqttQos.exactlyOnce);
//   //     mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//   //       final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
//   //       final String payload =
//   //           MqttPublishPayload.bytesToStringAsString(message.payload.message);
//   //       _processMqttMessage(payload);
//   //     });
//   //   } catch (e) {
//   //     print('Erro de conexão MQTT: $e');
//   //   }
//   // }

//   // void _onMqttConnected() {
//   //   print('Conectado ao broker MQTT');
//   // }

//   // void _onMqttDisconnected() {
//   //   print('Desconectado do broker MQTT');
//   // }

//   // void _onMqttPong() {
//   //   print('Recebido PONG do broker MQTT');
//   // }

//   void _processMqttMessage(String payload) {
//     // Processar e atualizar o banco de dados com o valor recebido do MQTT
//     // Por exemplo, você pode chamar um método para atualizar os dados no SQLite.
//     // Vou usar um método fictício chamado `atualizarDadosMqtt` como exemplo.
//     // Armazenamento().atualizarDadosMqtt(payload);

//     usuario.temperatura = double.parse(payload);
//     print("MQTT mensagem recebida: ${payload}");

//     // switch (payload[0]) {
//     //   case 't':
//     //     usuario.temperatura = double.parse(payload.substring(1));
//     //     break;
//     //   case 'a':
//     //     usuario.altura = double.parse(payload.substring(1));
//     //     usuario.calcular_imc();
//     //     break;
//     //   case 'p':
//     //     usuario.peso = double.parse(payload.substring(1));
//     //     usuario.calcular_imc();
//     //     break;
//     // }

//     // // Armazena novas infos no banco de dados
//     // Armazenamento storage = Armazenamento();
//     // storage.atualizarInfoAdicional(usuario.id, usuario.peso, usuario.temperatura, usuario.altura, usuario.imc);
//   }
// }