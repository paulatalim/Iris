import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                numero.replaceAll(".", AppLocalizations.of(context)!.dot), // Exemplo de formatação com 2 casas decimais
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
        if (texto == AppLocalizations.of(context)!.peso) {
          speech.speak("${AppLocalizations.of(context)!.peso} : ${usuario.peso} ${AppLocalizations.of(context)!.kg}");
        }
        
        if(texto ==  AppLocalizations.of(context)!.altura){
          speech.speak("${AppLocalizations.of(context)!.altura} : ${usuario.altura} ${AppLocalizations.of(context)!.m}.");
        }

        if(texto ==  AppLocalizations.of(context)!.temperatura){
          speech.speak("${AppLocalizations.of(context)!.temperatura} : ${usuario.temperatura} ${AppLocalizations.of(context)!.graus}.");
        }

        if(texto == AppLocalizations.of(context)!.imc){
          speech.speak("${AppLocalizations.of(context)!.imc} : ${usuario.imc}");
        }
      },

      child: _boxNumber(texto, numero, unidade),
    );
  }

  void _dialogo() async {
    if (usuario.temperatura > 0) {
      await speech.speak("Your temperature is ${usuario.temperatura} degrees Celsius");
      
      nenhumDadoColetado = false;
    }
    if (usuario.altura > 0) {
      await speech.speak("Your height is ${usuario.altura} meters");
      
      nenhumDadoColetado = false;
    }
    if (usuario.peso > 0) {
      await speech.speak("Your weight is ${usuario.peso} kilograms");
      
      nenhumDadoColetado = false;
    }
    if (usuario.imc > 0) {
      await speech.speak("Your BMI is ${usuario.imc}");
      
      nenhumDadoColetado = false;
    }
    if (nenhumDadoColetado) {
      await speech.speak("There is no information collected here yet, go to the devices section to get started.");
    }

    await speech.speak("Which section do you want to go to now?");
    
    do {
      resposta = await speech.listen();

      switch (resposta) {
        case "menu":
          _irUIMenu(0);
          respostaInvalida = false;
          break;

        case "devices":
          _irUIMenu(1);
          respostaInvalida = false;
          break;

        case "settings":
          _irUIMenu(3);
          respostaInvalida = false;
          break;

        case "information":
          await speech.speak("You are already in this section, tell me another section. If you are unsure which option you want, choose the menu option. So which section do you want to go to now?");
          respostaInvalida = false;
          break;

        default:
          await speech.speak("Hmm, I didn't hear you clearly. What do you want me to measure?");
      }
      
    } while (respostaInvalida);
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
    if(speech.controlarPorVoz) {
      _dialogo();
    }
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
            _clickableBoxNumber(AppLocalizations.of(context)!.peso, usuario.peso.toStringAsFixed(1), 'Kg'),
            _clickableBoxNumber(AppLocalizations.of(context)!.altura, usuario.altura.toStringAsFixed(2), 'm'),
            _clickableBoxNumber(AppLocalizations.of(context)!.temperatura, usuario.temperatura.toStringAsFixed(1), '°'),
            _clickableBoxNumber(AppLocalizations.of(context)!.imc, usuario.imc.toStringAsFixed(1), ''),
          ],
        ),
      ),
    );
  }
}
