import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blur/blur.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../voices.dart';
import '../control.dart';
import '../mqtt/MQTTManager.dart';
import '../mqtt/state/MQTTAppState.dart';
import '../storage/usuario.dart';

/// Classe com as propriedades dos dispositivos
class DispositivosDisponivel {
  String nome;
  String imagePath;
  String mensage;
  String status;

  DispositivosDisponivel({required this.nome, required this.imagePath, required this.mensage, required this.status});
}

// Lista dos dispositivos diponiveis
List<DispositivosDisponivel> dispositivo = [
  DispositivosDisponivel(
      nome: "Selecione um\ndispositivo",
      imagePath: 'assets/images/hardware.png',
      mensage: '',
      status: "Status"),

  DispositivosDisponivel(
      nome: "ESP 32", 
      imagePath: 'assets/images/esp32.png', 
      mensage: '',
      status: "Status"),

  DispositivosDisponivel(
      nome: "Termômetro", 
      imagePath: 'assets/images/termometro.png', 
      mensage: 'T',
      status: 'Processando ...'),

  DispositivosDisponivel(
      nome: "Sensor de Altura", 
      imagePath: 'assets/images/sensor.png',
      mensage: 'A',
      status: 'Calibrando sensor...'),

  DispositivosDisponivel(
      nome: "Balança", 
      imagePath: 'assets/images/balanca.png',
      mensage: 'P',
      status: 'Processando ...')
];



class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  late MQTTAppState currentAppState;
  late MQTTManager manager;

  DispositivosDisponivel dispositivoSelecionado = dispositivo[0];
  final scrollControl = ScrollController();
  String resposta = "";
  bool respostaInvalida = true;
  bool fazerNovaLeitura = false;
  String mqttMensage = "";

  @override
  void initState() {
    super.initState();
  }

  /// Estiliza um texto
  TextStyle styletext() {
    return GoogleFonts.inclusiveSans(
      textStyle: const TextStyle(
          color: Color(0xFF373B8A), fontSize: 20, fontWeight: FontWeight.w600),
    );
  }

  /// Estiliza os cards dos dispositivos
  BoxDecoration styleBox() {
    return BoxDecoration(
      color: const Color(0xFFdadcff),
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: const [
        BoxShadow(
            color: Color.fromARGB(90, 0, 0, 0),
            blurRadius: 10,
            offset: Offset(5, 5)),
        BoxShadow(
            color: Color.fromARGB(174, 255, 255, 255),
            blurRadius: 20,
            offset: Offset(-5, -5)),
      ],
    );
  }
  

  void dialogo() async {
    await voice.speek("Até agora eu sei ler temperatura, altura e medir peso, o que você deseja que eu meça?");
    await Future.delayed(Duration(seconds: 15));
    
    do {
      while (respostaInvalida) {
        await voice.hear();
        resposta = voice.resposta;

        if (resposta.compareTo("peso") == 0){
          respostaInvalida = false;
        }
        else if (resposta.compareTo("altura") == 0) {
          respostaInvalida= false;
        }
        else if (resposta.compareTo("temperatura") == 0) {
          respostaInvalida= false;
        } else {
          await voice.speek("Hummm não te escutei direito, o que você quer que eu meça?");
          await Future.delayed(Duration(seconds: 5));
    
        }
      }
      await voice.speek("Você deseja realizar uma nova leitura?");
      await Future.delayed(Duration(seconds: 5));
    
      respostaInvalida = true;

      while (respostaInvalida) {
        await voice.hear();
        resposta = voice.resposta;

        if (resposta.compareTo("sim") == 0) {
          await voice.speek("E o que deseja que eu meça agora? Seu peso? Sua altura? Ou sua temperatura?");
          await Future.delayed(Duration(seconds: 10));
    
          respostaInvalida = false;
        } else if (resposta.compareTo("não") == 0) {
          fazerNovaLeitura = false;
          respostaInvalida = false;
        } else {
          await voice.speek("Hummm não te escutei direito, repete de novo?");
          await Future.delayed(Duration(seconds: 5));
    
        }
        respostaInvalida = true;
      }
    } while (fazerNovaLeitura);
    
    await voice.speek("Para qual seção deseja ir agora?");
    await Future.delayed(Duration(seconds: 5));
    
    respostaInvalida = true;

    while (respostaInvalida) {
      await voice.hear();
      resposta = voice.resposta;
      
      if (resposta.compareTo("menu principal") == 0) {
        irUIMenu(0);
        
      } else if (resposta.compareTo("informações") == 0) {
        irUIMenu(2);
        
      } else if (resposta.compareTo("perfil") == 0) {
        irUIMenu(3);
        
      } else if (resposta.compareTo("informações") == 0) {
        await voice.speek("Você já está nessa seção, me diga outra seção. Caso estiver com dúvida de qual opção deseja, escolha a seção do menu principal. Então para qual seção deseja ir agora?");
        await Future.delayed(Duration(seconds: 10));
    
      } else {
        await voice.speek("Hummm não te escutei direito, repete de novo?");
        await Future.delayed(Duration(seconds: 5));
    
      }
    }
  }

  void irUIMenu (int index) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ControlScreen(index: index)
      )
    );
  }

  bool dialogoNaoInicializado = true;

  @override
  Widget build(BuildContext context) {
    if(dialogoNaoInicializado) {
      dialogoNaoInicializado = false;
      dialogo();
    }
    
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    
    currentAppState = appState;

    dispositivo[1].status = _prepareStateMessageFrom(currentAppState.getAppConnectionState);

    if(currentAppState.getAppConnectionState == MQTTAppConnectionState.disconnected) {
      _configureAndConnect();
      dispositivo[1].status = "Conectado";
                
    } else {
      // Captura da mensagem recebida pelo MQTT
      mqttMensage = currentAppState.getReceivedText;

      // Verifica se a mensagem eh vazia
      if (mqttMensage.compareTo("") != 0) {
        // Atribui o valor a variavel correta
        switch (currentAppState.getReceivedText.trim()[0]) {
          case 'T':
            dispositivo[2].status = "Concluído";
            usuario.temperatura = double.parse(currentAppState.getReceivedText.substring(1));
            break;
          case 'A':
          dispositivo[3].status = "Concluído";
            usuario.altura = double.parse(currentAppState.getReceivedText.substring(1));
            usuario.calcular_imc();
            break;
          case 'P':
            dispositivo[4].status = "Concluído";
            usuario.peso = double.parse(currentAppState.getReceivedText.substring(1));
            usuario.calcular_imc();
            break;
          case 'C':
            //mensagem de orientacao
            dispositivo[2].status = "Processando altura...";
            break;
        }
      } else {
        debugPrint("MQTT ERRO : mensagem captada vazia");
      }
    }

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
              padding: const EdgeInsets.only(top: 60),
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
                      dispositivoSelecionado.nome,
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
                      dispositivoSelecionado.imagePath,
                      height: 200,
                    ),
                    Text(
                      dispositivoSelecionado.status,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inclusiveSans(
                        textStyle: const TextStyle(
                          // color: Color(0xFF373B8A), // Cor do texto
                          color: Colors.white,
                          fontSize: 35, // Tamanho do texto
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              controller: scrollControl,
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
            )
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
          dispositivoSelecionado = dispositivo[id];
          manager.publish(dispositivo[id].mensage);
          scrollControl.animateTo(0,
              duration: const Duration(seconds: 1), curve: Curves.ease);
          });
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
                style: styletext(),
              ),
            ],
          ),
        ),
      
    ));
  }

  /// Verifica o status da coneccao do app com o broker e 
  /// retorna uma string indicando o status
  String _prepareStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Conectado';
      case MQTTAppConnectionState.connecting:
        return 'Conectando ...';
      case MQTTAppConnectionState.disconnected:
        return 'Desconectado';
    }
  }

  /// Configura e conecta o App com o mqtt
  void _configureAndConnect() {
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    manager = MQTTManager(
        host: 'test.mosquitto.org',
        topicPublish: 'iris/atuador',
        topicSubscribe: 'iris/sensor',
        identifier: osPrefix,
        state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();
  }
}
