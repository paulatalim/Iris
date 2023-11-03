import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'voices.dart';
import 'dart:core';

RecursoDeVoz texto_dados = RecursoDeVoz();

class Dados extends StatefulWidget {
  const Dados({super.key});

  @override
  State<Dados> createState() => _DadosState();
}

//Classe dados
class _DadosState extends State<Dados> {
  final double peso = 00;
  double temperatura = 00;
  final double altura = 00;
  final double imc = 00;

  //Criandos os containers
  Container boxNumber(String texto, String numero, String unidade) {
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
            style: GoogleFonts.inclusiveSans(
              textStyle: const TextStyle(
                fontSize: 22.0,
                color: Color(0xFF373B8A),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                numero, // Exemplo de formatação com 2 casas decimais
                style: GoogleFonts.inclusiveSans(
                  textStyle: const TextStyle(
                    fontSize: 25.0,
                    color: Color(0xFF373B8A),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                unidade, // Exemplo de formatação com 2 casas decimais
                style: GoogleFonts.inclusiveSans(
                  textStyle: const TextStyle(
                    fontSize: 25.0,
                    color: Color(0xFF373B8A),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Container clicável
  GestureDetector clickableBoxNumber(String texto, String numero, String unidade) {
    return GestureDetector(
      onTap: () {
        if (texto== "Peso ") {
          texto_dados.speek("peso : " + peso.toString() + "quilos");
        }
        if(texto== "Altura"){
          texto_dados.speek("altura : "+altura.toString()+"metros.");
        }

        if(texto== "Temperatura"){
          texto_dados.speek("temperatura : "+temperatura.toString()+"graus.");
        }

        if(texto== "IMC"){
          texto_dados.speek("IMC : "+imc.toString());
        }
      },

      child: boxNumber(texto, numero, unidade),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          clickableBoxNumber('Peso ', peso.toStringAsFixed(1), 'Kg'),
          clickableBoxNumber('Altura', altura.toStringAsFixed(2), 'm'),
          clickableBoxNumber('Temperatura', temperatura.toStringAsFixed(1), '°'),
          clickableBoxNumber('IMC', imc.toStringAsFixed(1), ''),
        ],
      ),
    );
  }
}
