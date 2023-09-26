import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  // color: Color.fromARGB(255, 0, 255, 55),
                  ),
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
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(73, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    // BorderRadius.circular(20)
                  ),
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
          ],
        ),
      ),
    );
  }
}
