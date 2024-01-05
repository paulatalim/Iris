import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:blur/blur.dart';

import '../hardware/bluetooth/bluetooth_manager.dart';
import '../hardware/available_devices.dart';
import '../recurso_de_voz/voices.dart';
import '../recurso_de_voz/loading.dart';
import '../storage/usuario.dart';

class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  DispositivosDisponivel dispositivoSelecionado = dispositivo[0];
  late BluetoothManager bluetooth;
  
  final scrollControl = ScrollController();

  String resposta = "";
  bool respostaInvalida = true;
  bool fazerNovaLeitura = false;
  bool dialogoNaoInicializado = true;
  late bool isRunning;

  @override
  void initState() {
    super.initState();
    bluetooth = BluetoothManager();
    isRunning = true;
  }

  @override
  void dispose() {
    super.dispose();
    isRunning = false;
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
        irUIMenu(0);
        
      } else if (resposta.compareTo("informações") == 0) {
        irUIMenu(2);
        
      } else if (resposta.compareTo("perfil") == 0) {
        irUIMenu(3);
        
      } else if (resposta.compareTo("informações") == 0) {
        await voice.speek("Você já está nessa seção, me diga outra seção. Caso estiver com dúvida de qual opção deseja, escolha a seção do menu principal. Então para qual seção deseja ir agora?");
        await Future.delayed(const Duration(seconds: 10));
    
      } else {
        await voice.speek("Hummm não te escutei direito, repete de novo?");
        await Future.delayed(const Duration(seconds: 5));
    
      }
    }
  }

  void irUIMenu(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ControlScreen(index: index)
      )
    );
  }

  void atualizarStatusSystem() async {
    while(isRunning) {
      setState(() {
        dispositivo[1].status = bluetooth.state;
        dispositivo[2].status = bluetooth.stateTemperatura;
        dispositivo[3].status = bluetooth.stateAltura;
        dispositivo[4].status = bluetooth.statePeso;
      });
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  

  @override
  Widget build(BuildContext context) {
    atualizarStatusSystem();
    
    // if(dialogoNaoInicializado) {
    //   dialogoNaoInicializado = false;
    //   dialogo();
    // }
    
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
                      dispositivoSelecionado.status!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inclusiveSans(
                        textStyle: const TextStyle(
                          // color: Color(0xFF373B8A), // Cor do texto
                          color: Colors.white,
                          fontSize: 35, // Tamanho do texto
                        ),
                      ),
                    ),
                    bluetooth.time != null 
                      ? Text(
                        bluetooth.time ?? "",
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
            dispositivoSelecionado = dispositivo[id];
            scrollControl.animateTo(0,
                duration: const Duration(seconds: 1), curve: Curves.ease);
            });

            switch(id) {
              case 2:
                // Mede a temperatura
                bluetooth.medirTemperatura();
                break;
              case 3:
                // Mede a altura
                bluetooth.medirAltura();
                break;
              case 4:
                // Mede o peso
                bluetooth.medirPeso();
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
                style: styletext(),
              ),
            ],
          ),
        ),
      
    ));
  }
}