import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
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
  String? _msgBT;

  Bluetooth (String? nomeDispositivo) {
    // Inicializa o blutooth
    _initBluetooth(nomeDispositivo);
  }

  Future<void> _initBluetooth(String? nomeDispositivo) async {
    // Tempo para esperar inicializacao
    await Future.delayed(Duration(seconds: 5));

    // Concessao de permissao para bluetooth
    await requestBluetoothPermissions();

    // Tempo para a concessao do bluetooth
    await Future.delayed(Duration(seconds: 10));

    // Informa quando a permissao ser condida
    print("[BLUETOOTH] Permissão Concedida");
    _status = "Permissao";
    print(_status);

    // Carrega os dispositivos disponiveis
    await _getBondedDevices();
    
    // Informa que os dispositivos foram carregados
    print("[BLUETOOTH] Dispositivos Blutooth Carregados");
    _status = 'Dispositivos Carregados';
    print(_status);

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
      print('bluetooth permitido');
      if (state[Permission.bluetoothConnect]!.isGranted) {
        print('bluetoothConnect permitido');
        if (state[Permission.bluetoothScan]!.isGranted) {
          print('bluetoothScan permitido');
          if (state[Permission.bluetoothAdvertise]!.isGranted) {
            print('bluetoothAdvertise permitido');
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
        print("[BLUETOOTH] Hardware Conectado");
        _status = "Conectado";
        print(_status);

        // Termina a busca pelo disposivo
        break;
      }
    }

    // Caso não encontrar o hardware
    if(_status?.compareTo("Conectado") != 0) {
      // Informa que o dispositivo não foi encontrado
      print("[BLUETOOTH] Hardware não encontrado");

      // Tempo de 2 segundo para reiniciar o procedimento
      await Future.delayed(Duration(seconds: 2));

      // Busca pelos dispositivos
      _getBondedDevices();
      startDiscovery();

      // Busca pelo hardware
      buscarHardware(nomeDispositivo);
    }
  }

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
      
      // Atualizacao dos _status
      connectedDevice = device;
      connected = true;
      
      // Inicia leitura
      listenBluetooth();

      // Salva o dispositivo
      salvarConeccao(device);
    } catch (error) {
      print('[BLUETOOTH] Erro de conexão: $error');
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
    print('[BLUETOOTH] Conectado ao disposiivo: $device["name"] - $device["adress"]');

    if(device["name"] != null && device["adress"] != null && !connected){
      try{
        // Conecta com o dispositivo encontrado
        connection = await BluetoothConnection.toAddress(device["adress"]);
        connectedDevice = BluetoothDevice(name: device["name"], address: device["adress"]);
        connected = true;
        listenBluetooth();

      } catch (e) {
        print('[BLUETOOTH] Erro ao reconectar dispositivo, aguarde 1 segundo');
        await Future.delayed(const Duration(seconds: 1));
        reconectarDispositivo();
      }
    }
  }

  get msgBT => _msgBT ?? '';
  get status => _status ?? '';
}