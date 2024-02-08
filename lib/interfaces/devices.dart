import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:blur/blur.dart';

import '../hardware/bluetooth/bluetooth_manager.dart';
import '../recurso_de_voz/speech_manager.dart';
import '../hardware/available_devices.dart';
import 'loading.dart';

class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  DispositivosDisponivel _dispositivoSelecionado = dispositivo[0];
  
  late BluetoothManager _bluetooth;
  late bool _isRunning;
  
  final _scrollControl = ScrollController();

  /// Estiliza um texto
  TextStyle _styletext() {
    return GoogleFonts.inclusiveSans(
      textStyle: const TextStyle(
          color: Color(0xFF373B8A), fontSize: 20, fontWeight: FontWeight.w600),
    );
  }
  
  void _dialogo() async {
    String resposta = "";
    bool respostaInvalida = true;
    bool fazerNovaLeitura = false;

    await speech.speak("Please wait a moment. I am connecting to the system");

    while(_bluetooth.state != "Connected") {
      
      await Future.delayed(const Duration(seconds: 1));
    }

    await speech.speak("Up to now, I can read temperature, height, and measure weight. What would you like me to measure?");
    
    do {
      respostaInvalida = true;
      while (respostaInvalida) {
        resposta = await speech.listen();

        switch (resposta) {
          case "weight":
            _dispositivoSelecionado = dispositivo[4];
            _bluetooth.medirPeso();

            do {
              await Future.delayed(const Duration(seconds: 1));
            } while(_bluetooth.isMeasuring);
            
            respostaInvalida = false;
            break;

          case "wait":
            _dispositivoSelecionado = dispositivo[4];
             _bluetooth.medirPeso();

            do {
              await Future.delayed(const Duration(seconds: 1));
            } while(_bluetooth.isMeasuring);
            
            respostaInvalida = false;
            break;

          case "height":
            _dispositivoSelecionado = dispositivo[3];
            _bluetooth.medirAltura();

            do {
              await Future.delayed(const Duration(seconds: 1));
            } while(_bluetooth.isMeasuring);
            
            respostaInvalida= false;
            break;
          
          case "temperature":
            _dispositivoSelecionado = dispositivo[2];
            _bluetooth.medirTemperatura();

            do {
              await Future.delayed(const Duration(seconds: 1));
            } while(_bluetooth.isMeasuring);
            
            respostaInvalida= false;
            break;

          default:
            _dispositivoSelecionado = dispositivo[0];
            await speech.speak("Hmm, I didn't hear you clearly. What do you want me to measure?");
            respostaInvalida = true; 
        }
      }

      await speech.speak("Do you want to perform a new reading?");

      respostaInvalida = true;

      while (respostaInvalida) {
        resposta = await speech.listen();

        switch(resposta) {
          case "yes":
            await speech.speak("What would you like me to measure now? Your weight? Your height? Or your temperature?");
            fazerNovaLeitura = true;
            respostaInvalida = false;
          
          case "no":
            fazerNovaLeitura = false;
            respostaInvalida = false;
          
          default:
            await speech.speak("Hmm, I didn't hear you. Can you repeat that again?");
        }
      }
    } while (fazerNovaLeitura);
    
    await speech.speak("Which section would you like to go to now");
    
    respostaInvalida = true;

    do {
      resposta = await speech.listen();

      switch (resposta) {
        case "menu":
          _irUIMenu(0);
          respostaInvalida = false;
          break;

        case "information":
          _irUIMenu(2);
          respostaInvalida = false;
          break;

        case "settings":
          _irUIMenu(3);
          respostaInvalida = false;
          break;

        case "devices":
          await speech.speak("You are already in this section, tell me another section. If you are unsure which option you want, choose the menu option. So which section do you want to go to now?");
          break;

        default:
          await speech.speak("Hmm, I didn't hear you. Can you repeat that again?");
      }
    } while (respostaInvalida);
  }

  void _irUIMenu(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadScreen(index: index)
      )
    );
  }

  void _atualizarStatusDevices() async {
    while(_isRunning) {
      setState(() {
        dispositivo[1].status = _bluetooth.state;
        dispositivo[2].status = _bluetooth.stateTemperatura;
        dispositivo[3].status = _bluetooth.stateAltura;
        dispositivo[4].status = _bluetooth.statePeso;
      });
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void _atualizarCronometroDevices() async {
    while(_isRunning) {
      setState(() {
        dispositivo[2].time = _bluetooth.timeTemperatura;
        dispositivo[3].time = _bluetooth.timeAltura;
        dispositivo[4].time = _bluetooth.timePeso;
      });
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  String _calcularTempo(int seconds) {
    if (seconds < 60) {
      return '$seconds s';
    } else if(seconds < 120 && seconds - 60 == 0) {
      return "1 min";
    } else if (seconds < 120) {
      return '1 min ${seconds - 60}';
    } else if (seconds - 120 == 0) {
      return '2 min';
    }

    return '2 min ${seconds - 120}';
  }

  @override
  void initState() {
    super.initState();
    // Inicializa variaveis
    _bluetooth = BluetoothManager();
    _isRunning = true;

    // Inicializa recursos
    _atualizarStatusDevices();
    _atualizarCronometroDevices();

    if(speech.controlarPorVoz) {
      _dialogo();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _isRunning = false;
  }

  @override
  Widget build(BuildContext context) {
    dispositivo[0].nome = AppLocalizations.of(context)!.selectDevice;
    dispositivo[1].nome = AppLocalizations.of(context)!.system;
    dispositivo[2].nome = AppLocalizations.of(context)!.thermometer;
    dispositivo[3].nome = AppLocalizations.of(context)!.hcsr04;
    dispositivo[4].nome = AppLocalizations.of(context)!.balance;
    
    _bluetooth.atualizarIdioma(
      AppLocalizations.of(context)!.connecting,
      AppLocalizations.of(context)!.connected,
      AppLocalizations.of(context)!.checkingConnection,
      AppLocalizations.of(context)!.processing,
      AppLocalizations.of(context)!.bluetoothNotInitializing,
      AppLocalizations.of(context)!.initializingBluetooth,
      AppLocalizations.of(context)!.searchingDevice,
      AppLocalizations.of(context)!.permission,
      AppLocalizations.of(context)!.concluded,
      AppLocalizations.of(context)!.calibratingSensor,
      AppLocalizations.of(context)!.calibratedSensor,
      AppLocalizations.of(context)!.guiHscr04,
      AppLocalizations.of(context)!.guiBalance,
      AppLocalizations.of(context)!.guiThermometer
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Color(0xFFbabdfa),
              Color(0xFFdba0ff),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 0.65 * MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Centralize verticalmente
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Centralize horizontalmente
                  children: [
                    Text(
                      _dispositivoSelecionado.nome,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inclusiveSans(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w600, // Tamanho do texto
                        ),
                      ),
                    ),
                    Image.asset(
                      _dispositivoSelecionado.imagePath,
                      height: 200,
                    ),
                    Text(
                      _dispositivoSelecionado.status!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inclusiveSans(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 35, // Tamanho do texto
                        ),
                      ),
                    ),
                    _dispositivoSelecionado.time != null 
                      ? Text(
                        "${AppLocalizations.of(context)!.time}: ${_calcularTempo(_dispositivoSelecionado.time!)}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inclusiveSans(
                          textStyle: const TextStyle(
                            color: Color(0xFF373B8A),
                            fontSize: 25,
                            fontWeight: FontWeight.w800
                          ),
                        ),) 
                      : const SizedBox(),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              controller: _scrollControl,
              child: Column(
                children: [
                  SizedBox(
                    height: 0.8 * MediaQuery.of(context).size.height,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 0.9 * MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      padding: const EdgeInsets.only(
                          top: 30.0, left: 0, right: 0, bottom: 60.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50,
                            height: 6,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(153, 78, 78, 78),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          SizedBox(
                            height: 0.7 * MediaQuery.of(context).size.height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                cardDispositivo(1),
                                const SizedBox(height: 30.0),
                                cardDispositivo(2),
                                const SizedBox(height: 30.0),
                                cardDispositivo(3),
                                const SizedBox(height: 30.0),
                                cardDispositivo(4),
                              ],
                            ),
                          ),
                        ],
                      )).frosted(
                    blur: 5,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ).animate()
                    .moveY(begin: -600, end: -15, duration: 1500.ms, curve: Curves.decelerate),
                ],
              ),
          ),
          ],
        ),
      ),
    );
  }

  /// Cria os cards dos dispositivos com as informacoes ligadas ao seu [id]
  Widget cardDispositivo(int id) {
    double? largura;
    double? altura = 45;

    if (id == 3 || id == 1) {
      largura = 50;
      altura = null;
    }

    return Container(
      width: 0.85 * MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        boxShadow: [
            BoxShadow(
                color: Color.fromARGB(90, 0, 0, 0),
                blurRadius: 10,
                offset: Offset(5, 5)),
            BoxShadow(
                color: Color.fromARGB(174, 255, 255, 255),
                blurRadius: 20,
                offset: Offset(-5, -5)),
            ]),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if(states.contains(MaterialState.pressed)) {
              return const Color.fromARGB(255, 170, 174, 255);
            }
            return const Color(0xFFdadcff);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            )
          ),
        ),
        onPressed: () {
          setState(() {
            if (!_bluetooth.isMeasuring && (_bluetooth.state == AppLocalizations.of(context)!.connected || id == 1)) {
              _dispositivoSelecionado = dispositivo[id];
            }
            _scrollControl.animateTo(0,
                duration: const Duration(seconds: 1), curve: Curves.ease);
          });

          if (!_bluetooth.isMeasuring && (_bluetooth.state == AppLocalizations.of(context)!.connected || id == 1)) {
            switch(id) {
              case 2:
                // Mede a temperatura
                _bluetooth.medirTemperatura();
                break;
              case 3:
                // Mede a altura
                _bluetooth.medirAltura();
                break;
              case 4:
                // Mede o peso
                _bluetooth.medirPeso();
                break;
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              Image.asset(
                dispositivo[id].imagePath,
                width: largura,
                height: altura,
              ),
              const SizedBox(width: 30.0),
              Text(
                dispositivo[id].nome,
                textAlign: TextAlign.center,
                style: _styletext(),
              ),
            ],
          ),
        ),
      
    ));
  }
}