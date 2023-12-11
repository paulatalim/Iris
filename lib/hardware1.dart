// import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class MqttHandler {
  String data = "";
  // late MqttServerClient client;

  void initMqtt () {
    String broker = 'test.mosquitto.org';
    int port = 1883;
    String clientIdentifier = 'android-turma124';
    String topic = 'iris/atuador/temperatura';
    
    mqtt.MqttClient client;
    mqtt.MqttConnectionState connectionState;
  }

  // Future<Object> connect() async {
  //   client = MqttServerClient.withPort('test.mosquitto.org', 'iris_mqtt', 1883);
  //   client.logging(on: true);
  //   client.onConnected = onConnected;
  //   client.onDisconnected = onDisconnected;
  //   client.onUnsubscribed = onUnsubscribed;
  //   client.onSubscribed = onSubscribed;
  //   client.onSubscribeFail = onSubscribeFail;
  //   client.pongCallback = pong;
  //   client.keepAlivePeriod = 60;
  //   client.logging(on: true);

  //   /// Set the correct MQTT protocol for mosquito
  //   client.setProtocolV311();

  //   final connMessage = MqttConnectMessage()
  //       .withWillTopic('willtopic')
  //       .withWillMessage('Will message')
  //       .startClean()
  //       .withWillQos(MqttQos.atMostOnce);

  //   print('MQTT_LOGS::Mosquitto client connecting....');

  //   client.connectionMessage = connMessage;
  //   try {
  //     await client.connect();
  //   } catch (e) {
  //     print('Exception: $e');
  //     client.disconnect();
  //   }

  //   if (client.connectionStatus!.state == MqttConnectionState.connected) {
  //     print('MQTT_LOGS::Mosquitto client connected');
  //   } else {
  //     print(
  //         'MQTT_LOGS::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
  //     client.disconnect();
  //     return -1;
  //   }

  //   print('MQTT_LOGS::Subscribing to the test/lol topic');
  //   const topic = 'iris/atuador/temperatura';
  //   client.subscribe(topic, MqttQos.atLeastOnce);

  //   client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
  //     final recMess = c![0].payload as MqttPublishMessage;
  //     final pt =
  //         MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

  //     data = pt;
  //     notifyListeners();
  //     print(
  //         'MQTT_LOGS:: Nova mensagem: topico eh <${c[0].topic}>, payload is $pt');
  //     print('');
  //   });

  //   return client;
  // }

  // void onConnected() {
  //   print('MQTT_LOGS:: Connected');
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

  // void publishMessage(String message) {
  //   const pubTopic = 'iris/atuador/temperatura';
  //   final builder = MqttClientPayloadBuilder();
  //   builder.addString(message);

  //   if (client.connectionStatus?.state == MqttConnectionState.connected) {
  //     client.publishMessage(pubTopic, MqttQos.atMostOnce, builder.payload!);
  //   }
  // }
}