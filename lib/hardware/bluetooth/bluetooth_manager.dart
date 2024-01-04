import 'bluetooth.dart';

import '../../storage/usuario.dart';
import '../available_devices.dart';

class BluetoothManager {
  late String nomeDispositivo;
  late Bluetooth bluetooth;
  String? _state;
  String? _stateAltura;
  String? _statePeso;
  String? _stateTemperatura;
  String? _time;

  int cronometroAltura = 30;
  int cronometroPeso = 30;
  int cronometroTemp = 30;

  bool salvarPeso = false;
  bool salvarTemperatura = false;

  BluetoothManager() {
    nomeDispositivo = "Iris Hardware";
    bluetooth = Bluetooth(nomeDispositivo);
    atualizarStatus();
  }

  void medirAltura() async{
    if(_stateAltura != null) {
      await bluetooth.publish("c");

      // Esperar um tempo
      while(cronometroAltura != 0) {
        _stateAltura = "Fique debaixo do sensor";
        _time = "Tempo para medir: $cronometroAltura s";

        cronometroAltura --;
        await Future.delayed(const Duration(seconds: 1));
      }

      _time = null;
      cronometroAltura = 30;

      _stateAltura = "Processando ...";

      await bluetooth.publish("a");
    }
  }

  void medirPeso() async {
    if(_statePeso != null) {
      while(cronometroPeso != 0) {
        _statePeso = "Suba na balança\nTempo para medir: $cronometroPeso s";
        _time = "Tempo para medir: $cronometroPeso s";

        cronometroPeso --;
        await Future.delayed(const Duration(seconds: 1));
      }

      _time = null;
      cronometroPeso = 30;
      _statePeso = "Processando ...";

      salvarPeso = true;
    }
  }

  void medirTemperatura() async {
    // Verifica se o sistema está conectado
    if(_stateTemperatura != null) {
      while(cronometroTemp != 0) {
        _stateTemperatura = "Coloque o sensor debaixo do braço";
        _time = "Tempo para medir: $cronometroTemp s";

        cronometroTemp --;
        await Future.delayed(const Duration(seconds: 1));
      }

      _time = null;
      cronometroTemp = 30;
      _stateTemperatura = "Processando ...";

      salvarTemperatura = true;
    }
  }

  void atualizarDados() async {
    while (true) {
      String msg = bluetooth.msgBT;

      if (msg.trim().isNotEmpty) {        
        switch (msg[0]) {
          case 'T':
            if(salvarTemperatura) {
              usuario.temperatura = double.parse(msg.substring(1));
              _stateTemperatura = 'Concluído';
              salvarTemperatura = false;
            }
            break;
          case 'A':
            usuario.altura = double.parse(msg.substring(1));
            _stateAltura = "Concluído";
            break;
          case 'P':
            if (salvarPeso) {
              usuario.peso = double.parse(msg.substring(1));
              _statePeso = "Concluído";
              salvarPeso = false;
            }
            break;
        }
      } 
      await Future.delayed(const Duration(milliseconds: 1000));
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
      
      // Atualiza status do sistema
      dispositivo[1].status = _state ?? "Status";

      // Aguarda 2 segundos até a proxima verificacao de status
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    _state = "Conectado";
    _stateTemperatura = 'Processando ...';
    _stateAltura = 'Calibrando sensor...';
    _statePeso = 'Processando ...';
    atualizarDados();
  }

  get state => _state ?? "Bluetooth não inicializado";
  get statePeso => _statePeso ?? "Conectando ...";
  get stateAltura => _stateAltura ?? "Conectando ...";
  get stateTemperatura => _stateTemperatura ?? "Conectando ...";
  get time => _time;
}