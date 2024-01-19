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

  int _cronometroAltura = 30;
  int _cronometroPeso = 30;
  int _cronometroTemp = 30;
  // int _cronometroCalibracao = 30;

  int? _timeAltura;
  int? _timePeso;
  int? _timeTemp;

  bool _salvarPeso = false;
  bool _salvarTemperatura = false;
  bool _salvarAltura = false;
  bool _isCalibrated = false;
  bool _sistemaConectado = false;
  // bool _alturaRecebida = false;
  // bool _enviarMsg = false;

  BluetoothManager() {
    nomeDispositivo = "Iris Hardware";
    bluetooth = Bluetooth(nomeDispositivo);
    atualizarStatus();
  }

  void calibrarSensor() async{
    late String msg;

    _timeAltura = 30;

    while(!_isCalibrated) {
      msg = bluetooth.msgBT;
      if(msg.trim().isNotEmpty) {
        if(msg.trim()[0] == 'C') {
          _stateAltura = "Calibrando sensor...";
          double time = double.parse(msg.substring(1));
          time /= 1000;
          _timeAltura = time.toInt();
        } else {
          _timeAltura = _timeAltura! - 1;
        }
      }

      if(_timeAltura! <= 0) {
        _timeAltura = 0;
      }
      
      await Future.delayed(const Duration(seconds: 1));
    }

    _timeAltura = null;
    _stateAltura = "Sensor calibrado";
  }

  void medirAltura() async{
    if(_stateAltura != null) {

      // Aguarda a calibracao do sensor
      while(!_isCalibrated) {
        await Future.delayed(const Duration(seconds: 2));
      }

      _stateAltura = "Fique debaixo do sensor";

      // Esperar um tempo
      while(_cronometroAltura != 0) {
        _timeAltura = _cronometroAltura;
        _cronometroAltura --;
        await Future.delayed(const Duration(seconds: 1));
      }

      _timeAltura = null;
      _cronometroAltura = 30;

      _stateAltura = "Processando ...";

      _salvarAltura = true;

      // while (!_alturaRecebida){
      //   await bluetooth.publish("a");
      //   await Future.delayed(const Duration(seconds: 1));
      // }

      // _alturaRecebida = false;
    }
  }

  void medirPeso() async {
    // Aguarda a conexao do sistema
    while(!_sistemaConectado) {
      await Future.delayed(Duration(seconds: 2));
    }

    // Atualiza status
    _statePeso = "Suba na balança";

    // Atualiza o conometro
    while(_cronometroPeso != 0) {
      _timePeso = _cronometroPeso;
      _cronometroPeso --;
      await Future.delayed(const Duration(seconds: 1));
    }

    // Atuaiza as variaveis
    _timePeso = null;
    _cronometroPeso = 30;
    _statePeso = "Processando ...";
    _salvarPeso = true;
  }

  void medirTemperatura() async {
    // Verifica se o sistema está conectado
    if(_stateTemperatura != null) {
      while(_cronometroTemp != 0) {
        _stateTemperatura = "Coloque o sensor debaixo do braço";

        _timeTemp = _cronometroPeso;
        _cronometroTemp --;
        await Future.delayed(const Duration(seconds: 1));
      }

      _timePeso = null;
      _cronometroTemp = 30;
      _stateTemperatura = "Processando ...";

      _salvarTemperatura = true;
    }
  }

  void atualizarDados() async {
    while (true) {
      String msg = bluetooth.msgBT;

      if (msg.trim().isNotEmpty) {
        switch (msg[0]) {
          case 'T':
            if(_salvarTemperatura) {
              usuario.temperatura = double.parse(msg.substring(1));
              _stateTemperatura = 'Concluído';
              _salvarTemperatura = false;
            }
            break;
          case 'A':
            _isCalibrated = true;

            if(_salvarAltura) {
              usuario.altura = double.parse(msg.substring(1));
              _stateAltura = "Concluído";
              _salvarAltura = false;
            }
            
            break;
          case 'P':
            if (_salvarPeso) {
              usuario.peso = double.parse(msg.substring(1));
              _statePeso = "Concluído";
              _salvarPeso = false;
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

    _state = "Verificando conexão";
    while (!_sistemaConectado){
      if(bluetooth.msgBT.trim().isNotEmpty) {
        if(bluetooth.msgBT.trim()[0] == 'S') {
          _sistemaConectado = true;
        }
      }
      await bluetooth.publish("S");
      await Future.delayed(const Duration(seconds: 1));
    }

    _state = "Conectado";
    _stateTemperatura = 'Processando ...';
    _statePeso = 'Processando ...';
    atualizarDados();
    calibrarSensor();
  }

  get state => _state ?? "Bluetooth não inicializado";
  get statePeso => _statePeso ?? "Conectando ...";
  get stateAltura => _stateAltura ?? "Conectando ...";
  get stateTemperatura => _stateTemperatura ?? "Conectando ...";
  get timeTemperatura => _timeTemp;
  get timeAltura => _timeAltura;
  get timePeso => _timePeso;
}