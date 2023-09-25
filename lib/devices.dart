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
        decoration: BoxDecoration(color: Colors.amber),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                // color: widget.corLavanda, // Usando a cor personalizada
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centralize verticalmente
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Centralize horizontalmente
                    children: [
                      Padding(
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
                        padding: EdgeInsets.only(
                            top: 0.0,
                            left: 20,
                            right: 0,
                            bottom: 0), // Adicione o padding desejado aqui
                        child: Image.asset(
                          'lib/hardware.png',
                          width: 300,
                          height: 300,
                        ),
                      ),
                      Padding(
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
              child: Container(
                // color: widget.corLavandaEscura,
                padding:
                    EdgeInsets.only(top: 30.0, left: 0, right: 0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 30,
                        height: MediaQuery.of(context).size.height - 720,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Ajuste o raio de arredondamento desejado
                          ),
                          elevation: 10,
                          // color: widget.corLavanda,
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Centraliza horizontalmente o Row
                              children: [
                                Image.asset(
                                  'lib/lamp.png',
                                  width:
                                      40, // Ajuste o tamanho da imagem conforme necessário
                                  height: 40,
                                ),
                                SizedBox(
                                    width:
                                        6.0), // Espaço entre a imagem e o texto
                                Text(
                                  'Nome do dispositivo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 30,
                        height: MediaQuery.of(context).size.height - 720,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Ajuste o raio de arredondamento desejado
                          ),
                          elevation: 10,
                          // color: widget.corLavanda,
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Centraliza horizontalmente o Row
                              children: [
                                Image.asset(
                                  'lib/lamp.png',
                                  width:
                                      40, // Ajuste o tamanho da imagem conforme necessário
                                  height: 40,
                                ),
                                SizedBox(
                                    width:
                                        6.0), // Espaço entre a imagem e o texto
                                Text(
                                  'Nome do dispositivo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 30,
                        height: MediaQuery.of(context).size.height - 720,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Ajuste o raio de arredondamento desejado
                          ),
                          elevation: 10,
                          // color: widget.corLavanda,
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Centraliza horizontalmente o Row
                              children: [
                                Image.asset(
                                  'lib/lamp.png',
                                  width:
                                      40, // Ajuste o tamanho da imagem conforme necessário
                                  height: 40,
                                ),
                                SizedBox(
                                    width:
                                        6.0), // Espaço entre a imagem e o texto
                                Text(
                                  'Nome do dispositivo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
