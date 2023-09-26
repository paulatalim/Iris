
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  final double peso = 00;
  final double temperatura = 00;
  final double altura = 00;
  final double imc = 00;
  final Color _iconColorPressed = const Color(0xFFA000FF);
  final Color _iconColorNotPressed = const Color(0xFF6B86EB);

  final List<Color> _iconColor = [
    const Color(0xFFA000FF),
    const Color(0xFF6B86EB),
    const Color(0xFF6B86EB),
    const Color(0xFF6B86EB)
  ];

  void _colorSelection(int index) {
    for (int i = 0; i < _iconColor.length; i++) {
      if (i != index) {
        _iconColor[i] = _iconColorNotPressed;
      } else {
        _iconColor[i] = _iconColorPressed;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFDBC4EF),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CaixaComNumero(texto: ' Peso:                 ' , numero: peso),
              CaixaComNumero(texto: ' Altura:                ', numero: altura),
              CaixaComNumero(texto: ' Temperatura:   ', numero: temperatura),
              CaixaComNumero(texto: ' IMC:                   ', numero: imc),
            ],
          ),
        ),
      ),
    );
  }
}

class CaixaComNumero extends StatelessWidget {
  final String texto;
  final double numero;

  CaixaComNumero({required this.texto, required this.numero});

  @override
  Widget build(BuildContext context) {
    //Caixinhas
    return Container(
      margin: EdgeInsets.all(30.0), //Espaço entre as caixinhas
      height: 80.0, // Defina a altura desejada, por exemplo, 100.0 pixels
      width: 300.0, // Defina a largura desejada, por exemplo, 200.0 pixels
      decoration: BoxDecoration(
        color: const Color(0xFFC5A7F1),
        //border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinha texto e número na mesma linha
        children: <Widget>[
          Padding(

            padding: const EdgeInsets.all(8.0),
            child:Text(
              '$texto ${numero.toStringAsFixed(2)}', // Exemplo de formatação com 2 casas decimais
              style: TextStyle(fontSize: 30.0),
            ),
          ),
        ],
      ),
    );
  }
}
