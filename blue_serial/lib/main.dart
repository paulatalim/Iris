import 'dart:typed_data';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'bluetooth.dart';
import 'blue.dart';

BluetoothConnection? connection;
BluetoothConnection? activeConnections;

bool connected = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Bluetooth bluetooth = Bluetooth("Iris Hardware");

class _MyHomePageState extends State<MyHomePage> {
  String _temp = "0";
  String status = "oi"; 

  Future<void> requestBluetoothPermissions() async {
    await Future.delayed(Duration(seconds: 5));
    final Map<Permission, PermissionStatus> status = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise
    ].request();

    if (status[Permission.bluetooth]!.isGranted) {
      print('bluetooth permitido');
      if (status[Permission.bluetoothConnect]!.isGranted) {
        print('bluetoothConnect permitido');
        if (status[Permission.bluetoothScan]!.isGranted) {
          print('bluetoothScan permitido');
          if (status[Permission.bluetoothAdvertise]!.isGranted) {
            print('bluetoothAdvertise permitido');
          }
        }
      }
    }
  }

  Future<void> _getBondedDevices() async {
    await Future.delayed(Duration(seconds: 10));
    List<BluetoothDevice> bondedDevices =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {
      discoveryResults = bondedDevices.map((device) {
        return BluetoothDiscoveryResult(
          device: device,
          rssi: -55,
        );
      }).toList();
    });
  }

  Future<void> initBluetooth() async {
    await requestBluetoothPermissions();
    print("Permissao");
    status = "Permissao";
    await _getBondedDevices();
    // print("carregango dispositivos");
    status = 'procurando hardware';

    
     
     print("Procurando hardware");

    for (int i = 0; i < discoveryResults.length; i++) {
      final device = discoveryResults[i].device;
      // while (device.name == null) {
      //   await Future.delayed(Duration(seconds: 1));
      // }
      print(device.name);
      if (device.name!.compareTo("Iris Hardware") == 0) {
        status = "Conectando";
        await _connectToDevice(device);
        status = "Conectado";
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // _getBondedDevices();
    // initBluetooth();
  }
    //loadConnectedDevice();
  // }

  Future<void> _startDiscovery() async {
    await Future.delayed(Duration(seconds: 15));
    setState(() {
      isDiscovering = true;
      discoveryResults = [];
    });

    FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      setState(() {
        discoveryResults.add(result);
      });
    });

    await Future.delayed(Duration(seconds: 10));
    FlutterBluetoothSerial.instance.cancelDiscovery();
    setState(() {
      isDiscovering = false;
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      setState(() {
        connectedDevice = device;
        connected = true;
      });
      publish("2");
      saveConnectedDevice(device);
    } catch (error) {
      print('Erro de conexão: $error');
    }
  }

  void saveConnectedDevice(BluetoothDevice device) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('connectedDeviceName', device.name ?? '');
    prefs.setString('connectedDeviceAddress', device.address);
  }

  @override
  Widget build(BuildContext context) {
    // temperatura();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(bluetooth.msgBT),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (connectedDevice != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Conectado a: ${connectedDevice!.name}"),
              ),
            ElevatedButton(
              onPressed: (){},
              child: Text('Buscar Novos Dispositivos'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xFFF07300)), // Altere a cor aqui
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: discoveryResults.length,
                itemBuilder: (context, index) {
                  final result = discoveryResults[index];
                  final device = result.device;
                  return ListTile(
                    title: Text(device.name ?? 'Nome Desconhecido'),
                    subtitle: Text(device.address),
                    onTap: () {
                      _connectToDevice(device);
                    },
                  );
                }
              )  
            ),
            Text(bluetooth.status, style: TextStyle(fontSize: 30),)
          ]
        ),     
    )
    );
  }
}
