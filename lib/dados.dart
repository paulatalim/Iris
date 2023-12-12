import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'voices.dart';
import 'dart:core';
import 'menu.dart';

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

  bool nenhumDadoColetado = true;
  bool respostaInvalida = true;
  String resposta = "";

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
          voice.speek("peso : $peso quilos");
        }
        if(texto== "Altura"){
          voice.speek("altura : $altura metros.");
        }

        if(texto== "Temperatura"){
          voice.speek("temperatura : $temperatura graus.");
        }

        if(texto== "IMC"){
          voice.speek("IMC : $imc");
        }
      },

      child: boxNumber(texto, numero, unidade),
    );
  }

  void listening() async {
    resposta = await voice.hear();
  }

  @override
  Widget build(BuildContext context) {

    if (temperatura > 0) {
      voice.speek("A sua temperatura é de $temperatura graus Celsius");
      nenhumDadoColetado = false;
    }
    if (altura > 0) {
      voice.speek("A sua altura é de $altura metros");
      nenhumDadoColetado = false;
    }
    if (peso > 0) {
      voice.speek("A seu peso é de $peso quilos");
      nenhumDadoColetado = false;
    }
    if (imc > 0) {
      voice.speek("A seu IMC é de $imc");
      nenhumDadoColetado = false;
    }
    if (nenhumDadoColetado) {
      voice.speek("Ainda não há nenhuma informação coletada aqui, vá para a seção de dispositivos para começar.");
    }

    voice.speek("Para qual seção deseja ir agora?");

    while (respostaInvalida) {
      listening();
      resposta = resposta.toLowerCase().trim();
      
      if (resposta.compareTo("menu principal") == 0) {
        setState(() {
          currentIndex = 0;
        });
      } else if (resposta.compareTo("dispositivos") == 0) {
        setState(() {
          currentIndex = 1;
        });
      } else if (resposta.compareTo("perfil") == 0) {
        setState(() {
          currentIndex = 2;
        });
      } else if (resposta.compareTo("informações") == 0) {
        voice.speek("Você já está nessa seção, me diga outra seção. Caso estiver com dúvida de qual opção deseja, escolha a seção do menu principal. Então, para qual seção deseja ir agora?");
      } else {
        voice.speek("Hummm não te escutei direito, repete de novo?");
      }
    }

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
