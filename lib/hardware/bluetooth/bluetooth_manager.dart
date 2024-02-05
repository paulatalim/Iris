import 'bluetooth.dart';

import '../../recurso_de_voz/speech_manager.dart';
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
  bool _isMeasuring = false;

  String connecting = '';
  String connected = '';
  String checkingConnection = '';
  String processing = '';
  String bluetoothNotInitializing = '';
  String initializingBluetooth = '';
  String searchingDevice = '';
  String permission = '';
  String concluded = '';
  String calibratingSensor = '';
  String calibratedSensor = '';
  String guiHscr04 = '';
  String guiBalance = '';
  String guiThermometer = '';

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
          _state = permission;

        } else {
          // Atualiza os status para encontrando um dispositivo
          _state = searchingDevice;
        }
      } else {
        // Enquanto não estiver permitido o bluetooth
        _state = initializingBluetooth;
      }
      
      // Atualiza status do sistema
      dispositivo[1].status = _state ?? "Status";

      // Aguarda 2 segundos até a proxima verificacao de status
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    _state = checkingConnection;
    while (!_sistemaConectado){
      String msg = _bluetooth.msgBT;

      if(msg.trim().isNotEmpty) {
        final dados = msg.split(",");

        for (int i = 0; i < dados.length; i++) {
          if(dados[i].trim()[0] == 'S') {
            _sistemaConectado = true;
            break;
          }
        }
      }
      await _bluetooth.publish("S");
      await Future.delayed(const Duration(seconds: 1));
    }

    _state = connected;
    _stateTemperatura = '$processing ...';
    _statePeso = '$processing ...';
    _atualizarDados();
    _calibrarSensor();
  }

  void _atualizarDados() async {
    while (true) {
      String msg = _bluetooth.msgBT;

      if (msg.trim().isNotEmpty) {

        final dados = msg.split(",");

        for (int i = 0; i < dados.length; i++) {

          switch (dados[i][0]) {
            case 'T':
              if(_salvarTemperatura) {
                usuario.temperatura = double.parse(dados[i].substring(1));

                await speech.speak("Your temperature is ${usuario.temperatura} degrees Celsius");
                _isMeasuring = false;

                _stateTemperatura = concluded;
                _salvarTemperatura = false;
                
              }
              break;
            case 'A':
              _isCalibrated = true;

              if(_salvarAltura) {
                usuario.altura = double.parse(dados[i].substring(1));

                await speech.speak("Your height is ${usuario.altura} meters");
                _isMeasuring = false;

                _stateAltura = concluded;
                _salvarAltura = false;
                
              }
              break;
            case 'P':
              if (_salvarPeso) {
                usuario.peso = double.parse(dados[i].substring(1));
                await speech.speak("Your weight is ${usuario.peso} kilograms");
                _isMeasuring = false;
                _statePeso = concluded;
                _salvarPeso = false;
              }
              break;
          }
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

      await speech.speak("I'm calibrating the sensor. Wait a minute");

      if(msg.trim().isNotEmpty) {

        final dados = msg.split(",");

        for(int i = 0; i < dados.length; i++) {
          if(dados[i].trim()[0] == 'C') {
            _stateAltura = "$calibratingSensor...";
            double time = double.parse(dados[i].substring(1));
            time /= 1000;
            _timeAltura = time.toInt();
          } else {
            _timeAltura = _timeAltura! - 1;
          }
        }
      }

      if(_timeAltura! <= 0) {
        _timeAltura = 0;
      }
      
      await Future.delayed(const Duration(seconds: 1));
    }

    _timeAltura = null;
    _stateAltura = calibratedSensor;
  }

  void medirAltura() async{
    // Aguarda a calibracao do sensor
    while(!_isCalibrated) {
      await Future.delayed(const Duration(seconds: 2));
    }

    _isMeasuring = true;

    // Atualiza status
    _stateAltura = guiHscr04;

    // Inicializa o cronometro
    _timeAltura = 30;

    await speech.speak("Stand under the sensor. You have 30 seconds for this");

    // Esperar um tempo
    while(_timeAltura! >= 0) {
      _timeAltura = _timeAltura! - 1;

      if (_timeAltura == 15) {
        await speech.speak("15 seconds left for measurement");
      }

      await Future.delayed(const Duration(seconds: 1));
    }

    _stateAltura = "$processing ...";
    await speech.speak("Processing your height");

    // Atualiza variaveis
    _timeAltura = null;
    _salvarAltura = true;
  }

  void medirPeso() async {
    // Aguarda a conexao do sistema
    while(!_sistemaConectado) {
      await Future.delayed(const Duration(seconds: 2));
    }

    _isMeasuring = true;

    // Atualiza status
    _statePeso = guiBalance;

    // Inicializa o cronometro
    _timePeso = 30;

    await speech.speak("Step on the weight scale. You have 30 seconds for this");

    // Atualiza o conometro
    while(_timePeso! > 0) {
      _timePeso = _timePeso! - 1;

      if (_timePeso == 15) {
        await speech.speak("15 seconds left for measurement");
      }

      await Future.delayed(const Duration(seconds: 1));
    }

    _statePeso = "$processing ...";
    await speech.speak("Processing your weight...");

    // Atuaiza as variaveis
    _timePeso = null;
    _salvarPeso = true;
  }

  void medirTemperatura() async {
    // Aguarda o sistema conectar
    while(!_sistemaConectado) {
      await Future.delayed(const Duration(seconds: 2));
    }

    _isMeasuring = true;

    // Atualiza status do sensor
    _stateTemperatura = guiThermometer;
    await speech.speak("Put the sensor in your armpit. You have 30 seconds for this");
    
    // Inicializa o cronometro
    _timeTemp = 30;
    
    // Controla o conometro
    while(_timeTemp! > 0) {
      _timeTemp = _timeTemp! - 1;

      if (_timeTemp == 15) {
        await speech.speak("15 seconds left for measurement");
      }

      await Future.delayed(const Duration(seconds: 1));
    }

    _stateTemperatura = "$processing ...";
    await speech.speak("Processing your temperature...");

    // Atualiza variaveis
    _timeTemp = null;
    _salvarTemperatura = true;
  }

  void atualizarIdioma(
      String connecting,
      String connected,
      String checkingConnection,
      String processing,
      String bluetoothNotInitializing,
      String initializingBluetooth,
      String searchingDevice,
      String permission,
      String concluded,
      String calibratingSensor,
      String calibratedSensor,
      String guiHscr04,
      String guiBalance,
      String guiThermometer,
    ) {
    this.connecting = connecting;
    this.connected = connected;
    this.checkingConnection = checkingConnection;
    this.processing = processing;
    this.bluetoothNotInitializing = bluetoothNotInitializing;
    this.initializingBluetooth = initializingBluetooth;
    this.searchingDevice = searchingDevice;
    this.permission = permission;
    this.concluded = concluded;
    this.calibratingSensor = calibratingSensor;
    this.calibratedSensor = calibratedSensor;
    this.guiHscr04 = guiHscr04;
    this.guiBalance = guiBalance;
    this.guiThermometer = guiThermometer;
  }

  get state => _state ?? bluetoothNotInitializing;
  get statePeso => _statePeso ?? "$connecting ...";
  get stateAltura => _stateAltura ?? "$connecting ...";
  get stateTemperatura => _stateTemperatura ?? "$connecting ...";
  get timeTemperatura => _timeTemp;
  get timeAltura => _timeAltura;
  get timePeso => _timePeso;
  get isMeasuring => _isMeasuring;
}