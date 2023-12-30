import 'bluetooth.dart';
import '../storage/usuario.dart';

class BluetoothManager {
  late String nomeDispositivo;
  late Bluetooth bluetooth;

  BluetoothManager() {
    nomeDispositivo = "Iris Hardware";
    bluetooth = Bluetooth(nomeDispositivo);
  }

  void atualizarDados() async {
    while (true) {
      if (bluetooth.msgBT.trim().isNotEmpty) {
        
        usuario.temperatura = double.parse(bluetooth.msgBT);
      } 
      await Future.delayed(const Duration(milliseconds: 2000));
    }
  }
}