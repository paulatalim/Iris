import 'dart:typed_data';
import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

List<BluetoothDiscoveryResult> discoveryResults = [];
bool isDiscovering = false;
BluetoothDevice? connectedDevice;
int cont = -5;

// class Bluetooth {
//   BluetoothConnection? activeConnections;
//   BluetoothConnection? connection;
//   BluetoothDevice? connectedDevice;

//   late List<BluetoothDiscoveryResult> discoveryResults;
//   late bool isDiscovering;

//   Bluetooth () {
//     discoveryResults = [];
//     bool isDiscovering = false;
//   }

//   void initBluetooth() {}

// }

Future<void> listenBluetooth() async {
  connection?.input?.listen((Uint8List data) {
    final msgBT = String.fromCharCodes(data);

    if (msgBT.isNotEmpty) {
      try {
        print('[BLUETOOTH] Mensagem recebida: $msgBT');
      } catch (e) {
        print("[BLUTOOTH] Erro ao receber mensagem");
      } 
    }
  });

  // if (msgBT == null) {
  //   cont ++;
  //   await Future.delayed(Duration(seconds: 2));
  // }

  // return Future.value(msgBT == null? "-1" : msgBT);
}

void publish(String mensage) async {
  listenBluetooth();

  String msgBT = mensage;
  try {
    connection!.output.add(Uint8List.fromList(msgBT.codeUnits));
    await connection!.output.allSent;
    print('[BLUETOOTH] Mensagem enviada: $msgBT');
  } catch (ex) {
    print('[BLUETOOTH] Erro ao enviar mensagem: $ex');
    connected = false;
    reconectarDispositivo();
  }
}

Future<void> reconectarDispositivo() async {
  final prefs = await SharedPreferences.getInstance();
  final deviceName = prefs.getString('connectedDeviceName');
  final deviceAddress = prefs.getString('connectedDeviceAddress');

  print('name: $deviceName - address: $deviceAddress');

  if(deviceName != null && deviceAddress != null && !connected){
    connection = await BluetoothConnection.toAddress(deviceAddress);
    connectedDevice = BluetoothDevice(name: deviceName, address: deviceAddress);
    connected = true;
    publish("1");
  }
}