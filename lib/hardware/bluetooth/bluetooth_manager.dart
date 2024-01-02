import 'bluetooth.dart';
import '../../storage/usuario.dart';

class BluetoothManager {
  late String nomeDispositivo;
  late Bluetooth bluetooth;
  String? _state;

  BluetoothManager() {
    nomeDispositivo = "Iris Hardware";
    bluetooth = Bluetooth(nomeDispositivo);
    atualizarStatus();
  }

  void atualizarDados() async {
    while (true) {
      if (bluetooth.msgBT.trim().isNotEmpty) {
        usuario.temperatura = double.parse(bluetooth.msgBT);
      } 
      await Future.delayed(const Duration(milliseconds: 2000));
    }
  }

  void atualizarStatus() async {
    // Atualizacao de status enquanto não ser conectado
    while(!bluetooth.connected) {
      // Verifica a permissao da coneccao
      if (bluetooth.isGranted) {
        // Verifica se está encontrando o dispositivo
        if (!bluetooth.isDiscovering) {
          // Atualiza os status para permissao concedida
          _state = "Permissão concedida";
        } else {
          // Atualiza os status para encontrando um dispositivo
          _state = "Procurando Dispositivo";
        }
      } else {
        // Enquanto não estiver permitido o bluetooth
        _state = "Inicializando bluetooth";
      }

      // Aguarda 2 segundos até a proxima verificacao de status
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    _state = "Conectado";
    atualizarDados();
  }

  get state => _state ?? "Bluetooth não inicializado";
}