import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';

class Bluetooth {
  List<BluetoothDiscoveryResult> _discoveryResults = [];
  BluetoothConnection? _connection;
  BluetoothDevice? _connectedDevice;
  String? _mensage;
  bool _connected = false;
  bool _isDiscovering = false;
  bool _isGranted = false;

  Bluetooth (String? nomeDispositivo) {
    // Inicializa o bluetooth
    _initBluetooth(nomeDispositivo);
  }

  Future<void> _initBluetooth(String? nomeDispositivo) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Tempo para esperar inicializacao
    await Future.delayed(const Duration(seconds: 2));

    // Concessao de permissao para bluetooth
    await _requestBluetoothPermissions();

    // Tempo para a concessao do bluetooth
    await Future.delayed(const Duration(seconds: 7));

    String? name = prefs.getString('_connectedDeviceName');

    // Verifica se o dispositivo requerido é uma conecção antiga
    if (name == null || name.compareTo(nomeDispositivo ?? '') != 0) {
      // Carrega os dispositivos disponiveis
      await _getBondedDevices();

      // Busca pelo harware para conectar com ele
      if (nomeDispositivo != null) {
        _buscarHardware(nomeDispositivo);
      }

    } else {
      _isDiscovering = true;
      _reconectarDispositivo();
    }
  }

  /// Requisita as permissoes do bluetooth
  Future<void> _requestBluetoothPermissions() async {
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

            // Informa quando a permissao ser condida
            debugPrint("[BLUETOOTH] Permissão Concedida");
            _isGranted = true;
          }
        }
      }
    }
  }

  Future<void> _getBondedDevices() async {
    List<BluetoothDevice> bondedDevices = await FlutterBluetoothSerial.instance.getBondedDevices();

    // Informa que os dispositivos foram carregados
    debugPrint("[BLUETOOTH] Dispositivos Blutooth Carregados");
    _isDiscovering = true;

    _discoveryResults = bondedDevices.map((device) {
      return BluetoothDiscoveryResult(
        device: device,
        rssi: -55,
      );
    }).toList();
  }

  /// Busca por um hardware especifico atraves de seu nome [nomeDispositivo]
  void _buscarHardware(String nomeDispositivo) async {
    // Busca pela lista de dispositivos encontrados
    for (int i = 0; i < _discoveryResults.length; i++) {
      final device = _discoveryResults[i].device;
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
    if(!_connected) {
      // Informa que o dispositivo não foi encontrado
      debugPrint("[BLUETOOTH] Hardware não encontrado");

      // Tempo de 2 segundo para reiniciar o procedimento
      await Future.delayed(const Duration(seconds: 2));

      // Busca pelos dispositivos
      _getBondedDevices();
      _startDiscovery();

      // Busca pelo hardware
      _buscarHardware(nomeDispositivo);
    }
  }

  /// Busca por mais dispositivos
  Future<void> _startDiscovery() async {
    _isDiscovering = true;
    _discoveryResults = [];
    
    FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      _discoveryResults.add(result);
    });

    await Future.delayed(const Duration(seconds: 10));
    FlutterBluetoothSerial.instance.cancelDiscovery();
    _isDiscovering = false;
  }

  /// Salva a conecção no armazenamento local
  void _salvarConeccao() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('_connectedDeviceName', _connectedDevice!.name ?? '');
    prefs.setString('_connectedDeviceAddress', _connectedDevice!.address);
  }

  /// Reconecta um disposivo onde seus dados de conecção 
  /// estão armazenados no armazenamento local
  Future<void> _reconectarDispositivo() async {
    // Cria instancia do armazenamento local
    final prefs = await SharedPreferences.getInstance();
    
    // Busca de dispositivo no armazenamento local
    Map<String, dynamic> device = {
      "name" : prefs.getString('_connectedDeviceName'),
      "adress" : prefs.getString('_connectedDeviceAddress')
    };

    // Informa o dispositivo resgatado
    debugPrint('[BLUETOOTH] Reconectando ao disposiivo: $device["name"] - $device["adress"]');
    _connectedDevice = BluetoothDevice(name: device["name"], address: device["adress"]);

    if(device["name"] != null && device["adress"] != null && !_connected){
      try{
        // Conecta com o dispositivo encontrado
        _connection = await BluetoothConnection.toAddress(device["adress"]);
        _connected = true;
        _listenBluetooth();

      } catch (e) {
        // Caso ocorrer um erro de coneccao
        debugPrint('[BLUETOOTH] Erro ao reconectar dispositivo, aguarde 1 segundo');

        // Reconecao com o dispositivo
        _connectToDevice(null);
      }
    }
  }

  /// Conecta um dispositivo
  /// Caso o Dispositivo [device], não ser informado
  /// será realizado a tentativa de coneccao com o 
  /// dispositivo salvo localmente
  Future<void> _connectToDevice(BluetoothDevice? device) async {
    try {
      // Atribuicao de um dispositivo, caso não ser informado
      _connectedDevice = device ?? _connectedDevice;

      // Conecta o dispositivo
      _connection = await BluetoothConnection.toAddress(_connectedDevice!.address);
      
      // Atualizacao dos status
      _connected = true;
      
      // Inicia leitura
      _listenBluetooth();

      // Salva o dispositivo
      _salvarConeccao();
    } catch (error) {
      // Informa erro de coneccao
      debugPrint('[BLUETOOTH] Erro de conexão: $error');

      // Tenta reconectar
      _connectToDevice(device);
    }
  }

  /// Recebe mensagem do bluetooth
  /// Esse método ápos ser chamado continua em loop 
  Future<void> _listenBluetooth() async {
    _connection?.input?.listen((Uint8List data) {
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
          _connected = false;
          _reconectarDispositivo();
        }
      }
    });
  }

  /// Envia mensagem via bluetooth para o dispositivo conectado
  /// A mensagem [mensage] é enviada
  Future<void> publish(String mensage) async {
    try {
      _connection!.output.add(Uint8List.fromList(mensage.codeUnits));
      await _connection!.output.allSent;
      debugPrint('[BLUETOOTH] Mensagem enviada: $mensage');
    } catch (ex) {
      debugPrint('[BLUETOOTH] Erro ao enviar mensagem: $ex');
      _connected = false;
      _reconectarDispositivo();
    }
  }

  /// Mensagem enviada via bluetooth
  get msgBT => _mensage ?? '';

  /// Status da permissão do bluetooth no app
  get isGranted => _isGranted;

  /// Status da conecção
  get connected => _connected;

  /// Status busca de dispositivos
  get isDiscovering => _isDiscovering;
}