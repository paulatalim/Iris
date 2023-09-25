import 'package:flutter/material.dart';

class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.blue[900]),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                    // color: Color.fromARGB(255, 255, 0, 0),
                    ),
                // color: widget.corLavanda, // Usando a cor personalizada
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centralize verticalmente
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Centralize horizontalmente
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 40.0, left: 0, right: 0, bottom: 0),
                        child: Text(
                          'Nome do dispositivo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white, // Cor do texto
                            fontSize: 18, // Tamanho do texto
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0,
                            left: 20,
                            right: 0,
                            bottom: 0), // Adicione o padding desejado aqui
                        child: Image.asset(
                          'assets/images/hardware.png',
                          width: 300,
                          // height: 300,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 0, left: 0, right: 0, bottom: 0),
                        child: Text(
                          'Conectando...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white, // Cor do texto
                            fontSize: 18, // Tamanho do texto
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0xAAFFFFFF),
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(90, 0, 0, 0),
                                  blurRadius: 15,
                                  offset: Offset(5, 5)),
                              BoxShadow(
                                  color: Color.fromARGB(200, 255, 255, 255),
                                  blurRadius: 13,
                                  offset: Offset(-5, -5)),
                            ],
                          ),
                          width: 0.85 * MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 30, top: 17, right: 30, bottom: 17),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Centraliza horizontalmente o Row
                            children: [
                              Image.asset(
                                'assets/images/lamp.png',
                                width: 40,
                              ),
                              const Text(
                                'Nome do dispositivo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(90, 0, 0, 0),
                                  blurRadius: 15,
                                  offset: Offset(5, 5)),
                              BoxShadow(
                                  color: Color.fromARGB(200, 255, 255, 255),
                                  blurRadius: 13,
                                  offset: Offset(-5, -5)),
                            ],
                          ),
                          width: 0.85 * MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 30, top: 17, right: 30, bottom: 17),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Centraliza horizontalmente o Row
                            children: [
                              Image.asset(
                                'assets/images/lamp.png',
                                width: 40,
                              ),
                              const Text(
                                'Nome do dispositivo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(90, 0, 0, 0),
                                  blurRadius: 15,
                                  offset: Offset(5, 5)),
                              BoxShadow(
                                  color: Color.fromARGB(200, 255, 255, 255),
                                  blurRadius: 13,
                                  offset: Offset(-5, -5)),
                            ],
                          ),
                          width: 0.85 * MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 30, top: 17, right: 30, bottom: 17),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Centraliza horizontalmente o Row
                            children: [
                              Image.asset(
                                'assets/images/lamp.png',
                                width: 40,
                              ),
                              const Text(
                                'Nome do dispositivo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
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
