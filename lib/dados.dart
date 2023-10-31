import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'usuario.dart';

class Dados extends StatefulWidget {
  const Dados({super.key});

  @override
  State<Dados> createState() => _DadosState();
}

class _DadosState extends State<Dados> {
  Container boxNumber(String texto, String numero, String unidade) {
    return Container(
      // margin: EdgeInsets.all(30.0), //Espaço entre as caixinhas
      height: 80.0, // Defina a altura desejada, por exemplo, 100.0 pixels
      width: 0.8 * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xFFdadcff),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(90, 0, 0, 0),
              blurRadius: 10,
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
                fontWeight: FontWeight.w600,
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
                    fontWeight: FontWeight.w600,
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
                    fontWeight: FontWeight.w600,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              boxNumber('Peso ', usuario.peso.toStringAsFixed(1), 'Kg'),
              boxNumber('Altura', usuario.altura.toStringAsFixed(2), 'm'),
              boxNumber(
                  'Temperatura', usuario.temperatura.toStringAsFixed(1), '°'),
              boxNumber('IMC', usuario.imc.toStringAsFixed(1), ''),
            ],
          ),
        ),
      ),
    );
  }
}
