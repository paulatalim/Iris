import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'voices.dart';
import 'menu.dart';
import 'control.dart';

class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  State<Devices> createState() => _DevicesState();
}

class DispositivosDisponivel {
  String nome;
  String imagePath;

  DispositivosDisponivel({required this.nome, required this.imagePath});
}

List<DispositivosDisponivel> dispositivo = [
  DispositivosDisponivel(
      nome: "Selecione um\ndispositivo",
      imagePath: 'assets/images/hardware.png'),
  DispositivosDisponivel(nome: "ESP 32", imagePath: 'assets/images/esp32.png'),
  DispositivosDisponivel(
      nome: "Termômetro", imagePath: 'assets/images/termometro.png'),
  DispositivosDisponivel(
      nome: "Sensor ultrassônico", imagePath: 'assets/images/sensor.png'),
  DispositivosDisponivel(
      nome: "Balança", imagePath: 'assets/images/balanca.png')
];

class _DevicesState extends State<Devices> {
  DispositivosDisponivel dispositivoSelecionado = dispositivo[0];
  String resposta = "";
  bool respostaInvalida = true;
  bool fazerNovaLeitura = false;

  TextStyle styletext() {
    return GoogleFonts.inclusiveSans(
      textStyle: const TextStyle(
          color: Color(0xFF373B8A), fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  BoxDecoration styleBox() {
    return BoxDecoration(
      color: const Color(0xFFe3c9f6),
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: const [
        BoxShadow(
            color: Color.fromARGB(90, 0, 0, 0),
            blurRadius: 10,
            offset: Offset(5, 5)),
        BoxShadow(
            color: Color.fromARGB(174, 255, 255, 255),
            blurRadius: 15,
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
   
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 75, bottom: 60),
          width: MediaQuery.of(context).size.width,
          height: 0.6 * MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Centralize verticalmente
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centralize horizontalmente
            children: [
              Text(
                dispositivoSelecionado.nome,
                textAlign: TextAlign.center,
                style: GoogleFonts.inclusiveSans(
                  textStyle: const TextStyle(
                    color: Color(0xFF373B8A), // Cor do texto
                    fontSize: 28,
                    fontWeight: FontWeight.w600, // Tamanho do texto
                  ),
                ),
              ),
              Image.asset(
                dispositivoSelecionado.imagePath,
                height: 200,
              ),
              Text(
                'Status',
                textAlign: TextAlign.center,
                style: GoogleFonts.inclusiveSans(
                  textStyle: const TextStyle(
                    color: Color(0xFF373B8A), // Cor do texto
                    fontSize: 25, // Tamanho do texto
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(73, 255, 255, 255),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    top: 50.0, left: 0, right: 0, bottom: 100.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            dispositivoSelecionado = dispositivo[1];
                          });
                        },
                        child: Container(
                          decoration: styleBox(),
                          width: 0.85 * MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 30, top: 17, right: 30, bottom: 17),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .start, // Centraliza horizontalmente o Row
                            children: [
                              Image.asset(
                                dispositivo[1].imagePath,
                                height: 40,
                              ),
                              const SizedBox(width: 30.0),
                              Text(
                                dispositivo[1].nome,
                                textAlign: TextAlign.center,
                                style: styletext(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            dispositivoSelecionado = dispositivo[2];
                          });
                        },
                        child: Container(
                          decoration: styleBox(),
                          width: 0.85 * MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 30, top: 17, right: 30, bottom: 17),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .start, // Centraliza horizontalmente o Row
                            children: [
                              Image.asset(
                                dispositivo[2].imagePath,
                                height: 50,
                              ),
                              const SizedBox(width: 30.0),
                              Text(
                                dispositivo[2].nome,
                                textAlign: TextAlign.center,
                                style: styletext(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            dispositivoSelecionado = dispositivo[3];
                          });
                        },
                        child: Container(
                          decoration: styleBox(),
                          width: 0.85 * MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 30, top: 17, right: 30, bottom: 17),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .start, // Centraliza horizontalmente o Row
                            children: [
                              Image.asset(
                                dispositivo[3].imagePath,
                                width: 40,
                              ),
                              const SizedBox(width: 30.0),
                              Text(
                                dispositivo[3].nome,
                                textAlign: TextAlign.center,
                                style: styletext(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            dispositivoSelecionado = dispositivo[4];
                          });
                        },
                        child: Container(
                          decoration: styleBox(),
                          width: 0.85 * MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 30, top: 17, right: 30, bottom: 17),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .start, // Centraliza horizontalmente o Row
                            children: [
                              Image.asset(
                                dispositivo[4].imagePath,
                                width: 40,
                              ),
                              const SizedBox(width: 30.0),
                              Text(
                                dispositivo[4].nome,
                                textAlign: TextAlign.center,
                                style: styletext(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
