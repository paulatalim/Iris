import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:blur/blur.dart';

import '../hardware/bluetooth/bluetooth_manager.dart';
import '../hardware/available_devices.dart';
import '../recurso_de_voz/voices.dart';
import 'loading.dart';
import '../storage/usuario.dart';

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

    await voice.speek("Até agora eu sei ler temperatura, altura e medir peso, o que você deseja que eu meça?");
    await Future.delayed(const Duration(seconds: 15));
    
    do {
      while (respostaInvalida) {
        await voice.hear();
        resposta = voice.resposta;

        if (resposta.compareTo("peso") == 0){
          await voice.speek("Suba na balança");
          await Future.delayed(const Duration(seconds: 10));
          await voice.speek("Estou medindo seu peso");
          // manager.publish(dispositivo[4].mensage);

          await voice.speek("Seu peso é de ${usuario.peso} quilos");
          await Future.delayed(const Duration(seconds: 5));

          respostaInvalida = false;
        }
        else if (resposta.compareTo("altura") == 0) {
          await voice.speek("Primeiro vou calibrar o sensor, não fique embaixo dele");
          await Future.delayed(const Duration(seconds: 10));
          
          await voice.speek("Sensor calibrando, agora fique debaixo do sensor");
          await Future.delayed(const Duration(seconds: 5));
          // manager.publish(dispositivo[2].mensage);
          
          await voice.speek("Medindo sua altura");
          await Future.delayed(const Duration(seconds: 30));

          await voice.speek("Sua altura é de ${usuario.altura} metros");
          await Future.delayed(const Duration(seconds: 5));

          respostaInvalida= false;
        }
        else if (resposta.compareTo("temperatura") == 0) {
          await voice.speek("Coloque o sensor debaixo do seu braço");
          // manager.publish(dispositivo[2].mensage);
          await Future.delayed(const Duration(seconds: 5));

          await voice.speek("Estou medindo sua temperatura");
          await Future.delayed(const Duration(seconds: 60));
          

          await voice.speek("Sua temperatura é de ${usuario.temperatura} graus Celsius");
          await Future.delayed(const Duration(seconds: 5));

          respostaInvalida= false;
        } else {
          await voice.speek("Hummm não te escutei direito, o que você quer que eu meça?");
          await Future.delayed(const Duration(seconds: 5));
          respostaInvalida = true;
        }
      }
      await voice.speek("Você deseja realizar uma nova leitura?");
      await Future.delayed(const Duration(seconds: 5));
    
      respostaInvalida = true;

      while (respostaInvalida) {
        await voice.hear();
        resposta = voice.resposta;

        if (resposta.compareTo("sim") == 0) {
          await voice.speek("E o que deseja que eu meça agora? Seu peso? Sua altura? Ou sua temperatura?");
          await Future.delayed(const Duration(seconds: 5));

          respostaInvalida = false;
        } else if (resposta.compareTo("não") == 0) {
          fazerNovaLeitura = false;
          respostaInvalida = false;
        } else {
          await voice.speek("Hummm não te escutei direito, repete de novo?");
          await Future.delayed(const Duration(seconds: 5));
    
        }
        respostaInvalida = true;
      }
    } while (fazerNovaLeitura);
    
    await voice.speek("Para qual seção deseja ir agora?");
    await Future.delayed(const Duration(seconds: 5));
    
    respostaInvalida = true;

    while (respostaInvalida) {
      await voice.hear();
      resposta = voice.resposta;
      
      if (resposta.compareTo("menu principal") == 0) {
        _irUIMenu(0);
        
      } else if (resposta.compareTo("informações") == 0) {
        _irUIMenu(2);
        
      } else if (resposta.compareTo("perfil") == 0) {
        _irUIMenu(3);
        
      } else if (resposta.compareTo("informações") == 0) {
        await voice.speek("Você já está nessa seção, me diga outra seção. Caso estiver com dúvida de qual opção deseja, escolha a seção do menu principal. Então para qual seção deseja ir agora?");
        await Future.delayed(const Duration(seconds: 10));
    
      } else {
        await voice.speek("Hummm não te escutei direito, repete de novo?");
        await Future.delayed(const Duration(seconds: 5));
    
      }
    }
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

  @override
  void initState() {
    super.initState();
    // Inicializa variaveis
    _bluetooth = BluetoothManager();
    _isRunning = true;

    // Inicializa recursos
    _atualizarStatusDevices();
    _atualizarCronometroDevices();
    // _dialogo();
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
                          // color: Color(0xFF373B8A), // Cor do texto
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
                          // color: Color(0xFF373B8A), // Cor do texto
                          color: Colors.white,
                          fontSize: 35, // Tamanho do texto
                        ),
                      ),
                    ),
                    _dispositivoSelecionado.time != null 
                      ? Text(
                        "${AppLocalizations.of(context)!.time}: ${_dispositivoSelecionado.time} s",
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
            _dispositivoSelecionado = dispositivo[id];
            _scrollControl.animateTo(0,
                duration: const Duration(seconds: 1), curve: Curves.ease);
            });

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