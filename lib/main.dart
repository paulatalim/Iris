import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color minhaCorPersonalizada = Color(0xFF6A5ACD); // Lavanda
    Color minhaCorEscura = Color(0xFF483D8B); // Lavanda Escuro

    return MaterialApp(
      home: Scaffold(
        body: MyHomePage(minhaCorPersonalizada, minhaCorEscura),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Color corLavanda;
  final Color corLavandaEscura;

  MyHomePage(this.corLavanda, this.corLavandaEscura);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: corLavanda, // Usando a cor personalizada
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
                    padding:
                        EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
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
            color: corLavandaEscura,
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
                      color: corLavanda,
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
                                width: 6.0), // Espaço entre a imagem e o texto
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
                      color: corLavanda,
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
                                width: 6.0), // Espaço entre a imagem e o texto
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
                      color: corLavanda,
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
                                width: 6.0), // Espaço entre a imagem e o texto
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
    );
  }
}
