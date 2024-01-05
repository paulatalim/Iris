import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import '../recurso_de_voz/loading.dart';
import '../recurso_de_voz/voices.dart';
import '../storage/usuario.dart';

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
        if (texto== "Peso ") {
          voice.speek("peso : ${usuario.peso} quilos");
        }
        if(texto== "Altura"){
          voice.speek("altura : ${usuario.altura} metros.");
        }

        if(texto== "Temperatura"){
          voice.speek("temperatura : ${usuario.temperatura} graus.");
        }

        if(texto== "IMC"){
          voice.speek("IMC : ${usuario.imc}");
        }
      },

      child: _boxNumber(texto, numero, unidade),
    );
  }

  void dialogo() async {
    if (usuario.temperatura > 0) {
      await voice.speek("A sua temperatura é de ${usuario.temperatura} graus Celsius");
      await Future.delayed(const Duration(seconds: 5));
      nenhumDadoColetado = false;
    }
    if (usuario.altura > 0) {
      await voice.speek("A sua altura é de ${usuario.altura} metros");
      await Future.delayed(const Duration(seconds: 5));
      nenhumDadoColetado = false;
    }
    if (usuario.peso > 0) {
      await voice.speek("A seu peso é de ${usuario.peso} quilos");
      await Future.delayed(const Duration(seconds: 5));
      nenhumDadoColetado = false;
    }
    if (usuario.imc > 0) {
      await voice.speek("A seu IMC é de ${usuario.imc}");
      await Future.delayed(const Duration(seconds: 5));
      nenhumDadoColetado = false;
    }
    if (nenhumDadoColetado) {
      await voice.speek("Ainda não há nenhuma informação coletada aqui, vá para a seção de dispositivos para começar.");
      await Future.delayed(const Duration(seconds: 10));
    }

    await voice.speek("Para qual seção deseja ir agora?");
    await Future.delayed(const Duration(seconds: 5));

    while (respostaInvalida) {
      // print(currentIndex);
      await voice.hear();
      resposta = voice.resposta;
      
      if (resposta.compareTo("menu principal") == 0) {
        irUIMenu(0);
      } else if (resposta.compareTo("dispositivos") == 0) {
        irUIMenu(1);
      } else if (resposta.compareTo("perfil") == 0) {
        irUIMenu(3);
      } else if (resposta.compareTo("informações") == 0) {
        await voice.speek("Você já está nessa seção, me diga outra seção. Caso estiver com dúvida de qual opção deseja, escolha a seção do menu principal. Então, para qual seção deseja ir agora?");
        await Future.delayed(const Duration(seconds: 10));
      } else {
        await voice.speek("Hummm não te escutei direito, repete de novo?");
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  void irUIMenu(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ControlScreen(index: index)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // if(dialogoNaoInicializado) {
    //   dialogoNaoInicializado = false;
    //   dialogo();
    // }

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
