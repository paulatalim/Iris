import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';

class Bluetooth {
  List<BluetoothDiscoveryResult> discoveryResults = [];
  bool isDiscovering = false;
  BluetoothConnection? connection;
  BluetoothConnection? activeConnections;
  BluetoothDevice? connectedDevice;
  bool connected = false;
  String? _status;
  String? _mensage;

  Bluetooth (String? nomeDispositivo) {
    // Inicializa o blutooth
    _initBluetooth(nomeDispositivo);
  }

  Future<void> _initBluetooth(String? nomeDispositivo) async {
    // Tempo para esperar inicializacao
    await Future.delayed(const Duration(seconds: 2));

    // Concessao de permissao para bluetooth
    await requestBluetoothPermissions();

    // Tempo para a concessao do bluetooth
    await Future.delayed(const Duration(seconds: 7));

    // Informa quando a permissao ser condida
    debugPrint("[BLUETOOTH] Permissão Concedida");
    _status = "Permissao";
    debugPrint(_status);

    // Carrega os dispositivos disponiveis
    await _getBondedDevices();
    
    // Informa que os dispositivos foram carregados
    debugPrint("[BLUETOOTH] Dispositivos Blutooth Carregados");
    _status = 'Dispositivos Carregados';
    debugPrint(_status);

    // Busca pelo harware para conectar com ele
    if (nomeDispositivo != null) {
      buscarHardware(nomeDispositivo);
    }
  }

  Future<void> requestBluetoothPermissions() async {
    final Map<Permission, PermissionStatus> state = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise
    ].request();

    if (state[Permission.bluetooth]!.isGranted) {
      debugPrint('bluetooth permitido');
      if (state[Permission.bluetoothConnect]!.isGranted) {
        debugPrint('bluetoothConnect permitido');
        if (state[Permission.bluetoothScan]!.isGranted) {
          debugPrint('bluetoothScan permitido');
          if (state[Permission.bluetoothAdvertise]!.isGranted) {
            debugPrint('bluetoothAdvertise permitido');
          }
        }
      }
    }
  }

  Future<void> _getBondedDevices() async {
    List<BluetoothDevice> bondedDevices = await FlutterBluetoothSerial.instance.getBondedDevices();

    discoveryResults = bondedDevices.map((device) {
      return BluetoothDiscoveryResult(
        device: device,
        rssi: -55,
      );
    }).toList();
  }

  void buscarHardware(String nomeDispositivo) async {
    // Busca pela lista de dispositivos encontrados
    for (int i = 0; i < discoveryResults.length; i++) {
      final device = discoveryResults[i].device;
      // Comparacao entre o nome do dispositivo e o nome requirido
      if (device.name!.compareTo(nomeDispositivo) == 0) {
        // Conecta ao dispositivo
        await _connectToDevice(device);

        // Informa que o harware está conectado
        debugPrint("[BLUETOOTH] Hardware Conectado");

        // Termina a busca pelo disposivo
        break;
      }
    }

    // Caso não encontrar o hardware
    if(_status?.compareTo("Conectado") != 0) {
      // Informa que o dispositivo não foi encontrado
      debugPrint("[BLUETOOTH] Hardware não encontrado");

      // Tempo de 2 segundo para reiniciar o procedimento
      await Future.delayed(const Duration(seconds: 2));

      // Busca pelos dispositivos
      _getBondedDevices();
      startDiscovery();

      // Busca pelo hardware
      buscarHardware(nomeDispositivo);
    }
  }

  Future<void> _listenBluetooth() async {
    connection?.input?.listen((Uint8List data) {
      final msgBT = String.fromCharCodes(data);

      if (msgBT.isNotEmpty) {
        try {
          // Evita que mensagens vazias sejam salvas
          if (msgBT.trim().isNotEmpty) {
            _mensage = msgBT;
          }

          // Informa o valor recebido
          debugPrint('[BLUETOOTH] Mensagem recebida: $msgBT');
        } catch (e) {
          debugPrint("[BLUTOOTH] Erro ao receber mensagem");
        }
      }
    });
  }

  void publish(String mensage) async {
    try {
      connection!.output.add(Uint8List.fromList(mensage.codeUnits));
      await connection!.output.allSent;
      debugPrint('[BLUETOOTH] Mensagem enviada: $mensage');
    } catch (ex) {
      debugPrint('[BLUETOOTH] Erro ao enviar mensagem: $ex');
      connected = false;
      reconectarDispositivo();
    }
  }

  Future<void> startDiscovery() async {
    isDiscovering = true;
    discoveryResults = [];
    
    FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      discoveryResults.add(result);
    });

    await Future.delayed(const Duration(seconds: 10));
    FlutterBluetoothSerial.instance.cancelDiscovery();
    isDiscovering = false;
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      // Conecta o dispositivo
      connection = await BluetoothConnection.toAddress(device.address);
      
      // Atualizacao dos status
      connectedDevice = device;
      connected = true;
      _status = "Conectado";
      
      // Inicia leitura
      _listenBluetooth();

      // Salva o dispositivo
      salvarConeccao(device);
    } catch (error) {
      debugPrint('[BLUETOOTH] Erro de conexão: $error');
      _connectToDevice(device);
    }
  }

  void salvarConeccao(BluetoothDevice device) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('connectedDeviceName', device.name ?? '');
    prefs.setString('connectedDeviceAddress', device.address);
  }

  Future<void> reconectarDispositivo() async {
    // Cria instancia do armazenamento local
    final prefs = await SharedPreferences.getInstance();
    
    // Busca de dispositivo no armazenamento local
    Map<String, dynamic> device = {
      "name" : prefs.getString('connectedDeviceName'), 
      "adress" : prefs.getString('connectedDeviceAddress')
    };

    // Informa o dispositivo resgatado
    debugPrint('[BLUETOOTH] Conectado ao disposiivo: $device["name"] - $device["adress"]');

    if(device["name"] != null && device["adress"] != null && !connected){
      try{
        // Conecta com o dispositivo encontrado
        connection = await BluetoothConnection.toAddress(device["adress"]);
        connectedDevice = BluetoothDevice(name: device["name"], address: device["adress"]);
        connected = true;
        _status = "Conectado";
        _listenBluetooth();

      } catch (e) {
        debugPrint('[BLUETOOTH] Erro ao reconectar dispositivo, aguarde 1 segundo');
        await Future.delayed(const Duration(seconds: 1));
        reconectarDispositivo();
      }
    }
  }

  get msgBT => _mensage ?? '';
  get status => _status ?? '';
}