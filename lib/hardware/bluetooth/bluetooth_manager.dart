import 'bluetooth.dart';

import '../../storage/usuario.dart';
import '../available_devices.dart';

class BluetoothManager {
  late String _nomeDispositivo;
  late Bluetooth _bluetooth;
  String? _state;
  String? _stateAltura;
  String? _statePeso;
  String? _stateTemperatura;

  int? _timeAltura;
  int? _timePeso;
  int? _timeTemp;

  bool _salvarPeso = false;
  bool _salvarTemperatura = false;
  bool _salvarAltura = false;
  bool _isCalibrated = false;
  bool _sistemaConectado = false;

  BluetoothManager() {
    _nomeDispositivo = "Iris Hardware";
    _bluetooth = Bluetooth(_nomeDispositivo);
    _atualizarStatus();
  }

  void _atualizarStatus() async {
    // Atualizacao de status enquanto não ser conectado
    while(!_bluetooth.connected) {
      // Verifica a permissao da coneccao
      if (_bluetooth.isGranted) {
        // Verifica se está encontrando o dispositivo
        if (!_bluetooth.isDiscovering) {
          // Atualiza os status para permissao concedida
          _state = "Permissão concedida";

        } else {
          // Atualiza os status para encontrando um dispositivo
          _state = "Procurando Dispositivo";
        }
      } else {
        // Enquanto não estiver permitido o bluetooth
        _state = "Inicializando _bluetooth";
      }
      
      // Atualiza status do sistema
      dispositivo[1].status = _state ?? "Status";

      // Aguarda 2 segundos até a proxima verificacao de status
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    _state = "Verificando conexão";
    while (!_sistemaConectado){
      if(_bluetooth.msgBT.trim().isNotEmpty) {
        if(_bluetooth.msgBT.trim()[0] == 'S') {
          _sistemaConectado = true;
        }
      }
      await _bluetooth.publish("S");
      await Future.delayed(const Duration(seconds: 1));
    }

    _state = "Conectado";
    _stateTemperatura = 'Processando ...';
    _statePeso = 'Processando ...';
    _atualizarDados();
    _calibrarSensor();
  }

  void _atualizarDados() async {
    while (true) {
      String msg = _bluetooth.msgBT;

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

  void _calibrarSensor() async{
    late String msg;

    _timeAltura = 30;

    while(!_isCalibrated) {
      msg = _bluetooth.msgBT;
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
    // Aguarda a calibracao do sensor
    while(!_isCalibrated) {
      await Future.delayed(const Duration(seconds: 2));
    }

    // Atualiza status
    _stateAltura = "Fique debaixo do sensor";

    // Inicializa o cronometro
    _timeAltura = 30;

    // Esperar um tempo
    while(_timeAltura != 0) {
      _timeAltura = _timeAltura! - 1;
      await Future.delayed(const Duration(seconds: 1));
    }

    // Atualiza variaveis
    _timeAltura = null;
    _stateAltura = "Processando ...";
    _salvarAltura = true;
  }

  void medirPeso() async {
    // Aguarda a conexao do sistema
    while(!_sistemaConectado) {
      await Future.delayed(const Duration(seconds: 2));
    }

    // Atualiza status
    _statePeso = "Suba na balança";

    // Inicializa o cronometro
    _timePeso = 30;

    // Atualiza o conometro
    while(_timePeso != 0) {
      _timePeso = _timePeso! - 1;
      await Future.delayed(const Duration(seconds: 1));
    }

    // Atuaiza as variaveis
    _timePeso = null;
    _statePeso = "Processando ...";
    _salvarPeso = true;
  }

  void medirTemperatura() async {
    // Aguarda o sistema conectar
    while(!_sistemaConectado) {
      await Future.delayed(const Duration(seconds: 2));
    }
    
    // Atualiza status do sensor
    _stateTemperatura = "Coloque o sensor debaixo do braço";

    // Inicializa o cronometro
    _timeTemp = 30;
    
    // Controla o conometro
    while(_timeTemp != 0) {
      _timeTemp = _timeTemp! - 1;
      await Future.delayed(const Duration(seconds: 1));
    }

    // Atualiza variaveis
    _timePeso = null;
    _stateTemperatura = "Processando ...";
    _salvarTemperatura = true;
  }

  get state => _state ?? "_Bluetooth não inicializado";
  get statePeso => _statePeso ?? "Conectando ...";
  get stateAltura => _stateAltura ?? "Conectando ...";
  get stateTemperatura => _stateTemperatura ?? "Conectando ...";
  get timeTemperatura => _timeTemp;
  get timeAltura => _timeAltura;
  get timePeso => _timePeso;
}