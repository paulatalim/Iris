import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'armazenamento.dart';

class MqttHelper {
  late MqttServerClient mqttClient;
  final String mqttTopic = 'seu-topico-mqtt';

  Future<void> initMqtt() async {
    mqttClient = MqttServerClient('mqtt.eclipse.org', '');
    mqttClient.logging(on: true);

    mqttClient.onConnected = _onMqttConnected;
    mqttClient.onDisconnected = _onMqttDisconnected;
    mqttClient.pongCallback = _onMqttPong;

    await _connectToMqtt();
  }

  Future<void> _connectToMqtt() async {
    try {
      await mqttClient.connect();
      mqttClient.subscribe(mqttTopic, MqttQos.exactlyOnce);
      mqttClient.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        final String payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        _processMqttMessage(payload);
      });
    } catch (e) {
      print('Erro de conexão MQTT: $e');
    }
  }

  void _onMqttConnected() {
    print('Conectado ao broker MQTT');
  }

  void _onMqttDisconnected() {
    print('Desconectado do broker MQTT');
  }

  void _onMqttPong() {
    print('Recebido PONG do broker MQTT');
  }

  void _processMqttMessage(String payload) {
    // Processar e atualizar o banco de dados com o valor recebido do MQTT
    // Por exemplo, você pode chamar um método para atualizar os dados no SQLite.
    // Vou usar um método fictício chamado `atualizarDadosMqtt` como exemplo.
    Armazenamento().atualizarDadosMqtt(payload);
  }
}