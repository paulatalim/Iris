import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Configuracao extends StatefulWidget {
  const Configuracao({super.key});

  @override
  State<Configuracao> createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {
  double valor = 50;

  List<Color> backgroundColor = [Colors.red, Colors.blue];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.pink),
      child: Scaffold(
        // backgroundColor: const Color.fromARGB(255, 204, 201, 221),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 100)),

              // Informa o titulo da pagina
              const Text(
                "Configuração",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    color: Color(0xFF5100FF)),
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
                  color: const Color(0xFFA99DE6),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Volume'),
                    Slider(
                        value: valor, //definir o valor inicial
                        min: 0,
                        max: 85,
                        // label: 'Volume', //label dinamico
                        divisions:
                            10, //define as divisoes entre o minimo e o maximo
                        activeColor: const Color(0xFF5100FF),
                        inactiveColor: Colors.black12,
                        onChanged: (double novoValor) {
                          setState(() {
                            valor = novoValor;
                          });
                        }),
                  ],
                ),
              ),

              // Gap entre elementos
              const SizedBox(
                height: 30,
              ),

              // Compo da velocidade
              Container(
                width: 0.7 * MediaQuery.of(context).size.width,
                height: 0.1 * MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(
                    left: 30, top: 10, right: 30, bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFA99DE6),
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
      ),
    );
  }
}
