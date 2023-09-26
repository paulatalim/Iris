import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dados extends StatefulWidget {
  const Dados({super.key});

  @override
  State<Dados> createState() => _DadosState();
}

class _DadosState extends State<Dados> {
  NumberFormat formatAltura = NumberFormat(
    "0,00",
  );
  final double peso = 00;
  double temperatura = 00;
  final double altura = 00;
  final double imc = 00;

  Container boxNumber(String texto, double numero) {
    return Container(
      // margin: EdgeInsets.all(30.0), //Espaço entre as caixinhas
      height: 80.0, // Defina a altura desejada, por exemplo, 100.0 pixels
      width: 0.8 * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xFFC7C9FF),
        borderRadius: BorderRadius.circular(20.0),
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
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Alinha texto e número na mesma linha
        children: <Widget>[
          Text(
            texto, // Exemplo de formatação com 2 casas decimais
            style: TextStyle(fontSize: 25.0),
          ),
          Text(
            '${numero.toStringAsFixed(2)}', // Exemplo de formatação com 2 casas decimais
            style: TextStyle(fontSize: 25.0),
          ),
        ],
      ),
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
              Color(0xFFDFE0FB),
              Color(0xFFECCCFF),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              boxNumber('Peso: ', peso),
              boxNumber('Altura:', altura),
              boxNumber('Temperatura:', temperatura),
              boxNumber('IMC:', imc),
            ],
          ),
        ),
      ),
    );
  }
}
