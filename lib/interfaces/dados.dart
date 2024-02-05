import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import '../recurso_de_voz/speech_manager.dart';
import '../storage/usuario.dart';
import 'loading.dart';

class Dados extends StatefulWidget {
  const Dados({super.key});

  @override
  State<Dados> createState() => _DadosState();
}

/// Classe da interface e monitoramento do hardware
class _DadosState extends State<Dados> {
  bool dialogoNaoInicializado = true;
  bool nenhumDadoColetado = true;
  bool respostaInvalida = true;
  String resposta = "";

  /// Cria o card onde possui os dados do usuario
  Container _boxNumber(String texto, String numero, String unidade) {
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

  /// Cria um botao que ao ser clicado eh falado o valor do campo para o usuario
  /// Cria um campo com o nome [texto], o valor [numero] e com sua unidade de medida [unidade]
  /// Retorna a caixa pronta [GesturesDetector]
  GestureDetector _clickableBoxNumber(String texto, String numero, String unidade) {
    return GestureDetector(
      onTap: () {
        if (texto == "Peso ") {
          speech.speak("peso : ${usuario.peso} quilos");
        } 

        else if (texto == "Altura"){
          speech.speak("altura : ${usuario.altura} metros.");
        }

        else if (texto == "Temperatura"){
          speech.speak("temperatura : ${usuario.temperatura} graus.");
        }

        else if (texto == "IMC"){
          speech.speak("IMC : ${usuario.imc}");
        }
      },

      child: _boxNumber(texto, numero, unidade),
    );
  }

  void _dialogo() async {
    if (usuario.temperatura > 0) {
      await speech.speak("A sua temperatura é de ${usuario.temperatura} graus Celsius");
      
      nenhumDadoColetado = false;
    }
    if (usuario.altura > 0) {
      await speech.speak("A sua altura é de ${usuario.altura} metros");
      
      nenhumDadoColetado = false;
    }
    if (usuario.peso > 0) {
      await speech.speak("A seu peso é de ${usuario.peso} quilos");
      
      nenhumDadoColetado = false;
    }
    if (usuario.imc > 0) {
      await speech.speak("A seu IMC é de ${usuario.imc}");
      
      nenhumDadoColetado = false;
    }
    if (nenhumDadoColetado) {
      await speech.speak("Ainda não há nenhuma informação coletada aqui, vá para a seção de dispositivos para começar.");
    }

    await speech.speak("Para qual seção deseja ir agora?");
    
    while (respostaInvalida) {
      resposta = await speech.listen();

      switch (resposta) {
        case "menu principal":
          _irUIMenu(0);
          break;

        case "dispositivos":
          _irUIMenu(1);
          break;

        case "perfil":
          _irUIMenu(3);
          break;

        case "informações":
          await speech.speak("Você já está nessa seção, me diga outra seção. Caso estiver com dúvida de qual opção deseja, escolha a seção do menu principal. Então, para qual seção deseja ir agora?");
          break;

        default:
          await speech.speak("Hummm não te escutei direito, repete de novo?");
      
      }
    }
  }

  void _irUIMenu(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadScreen(index: index)
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _dialogo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _clickableBoxNumber('Peso ', usuario.peso.toStringAsFixed(1).replaceAll(".", ","), 'Kg'),
            _clickableBoxNumber('Altura', usuario.altura.toStringAsFixed(2).replaceAll(".", ","), 'm'),
            _clickableBoxNumber('Temperatura', usuario.temperatura.toStringAsFixed(1).replaceAll(".", ","), '°'),
            _clickableBoxNumber('IMC', usuario.imc.toStringAsFixed(1).replaceAll(".", ","), ''),
          ],
        ),
      ),
    );
  }
}
