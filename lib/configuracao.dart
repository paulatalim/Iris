import 'package:flutter/material.dart';

class Configuracao extends StatefulWidget {
  const Configuracao({super.key});

  @override
  State<Configuracao> createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {
  double valor = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Informa o titulo da pagina
            const Text(
              "Configuração",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Calibri',
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Colors.red),
            ),

            // Gap entre elementos
            const SizedBox(
              height: 80,
            ),

            // Campo do volume
            Container(
              width: 0.7 * MediaQuery.of(context).size.width,
              height: 0.1 * MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(
                  left: 30, top: 10, right: 30, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Volume'),
                  Slider(
                      value: valor, //definir o valor inicial
                      min: 0,
                      max: 100,
                      label: 'Volume', //label dinamico
                      divisions:
                          10, //define as divisoes entre o minimo e o maximo
                      activeColor: Colors.red,
                      inactiveColor: Colors.black12,
                      onChanged: (double novoValor) {
                        setState(() {
                          valor = novoValor;
                          // label = "seleção: " + novoValor.toString();
                        });
                      }),
                ],
              ),
            ),

            // Gap entre elementos
            const SizedBox(
              height: 80,
            ),

            // Compo da velocidade
            Container(
              width: 0.7 * MediaQuery.of(context).size.width,
              height: 0.1 * MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(
                  left: 30, top: 10, right: 30, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Velocidade'),
                  Text('0'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
