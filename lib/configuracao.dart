import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'menu.dart';
import 'voices.dart';

class Configuracao extends StatefulWidget {
  const Configuracao({super.key});

  @override
  State<Configuracao> createState() => _ConfiguracaoState();
}

List<String> speeds = <String>['0.5x', '1.0x', '1.5x'];

class _ConfiguracaoState extends State<Configuracao> {
  String resposta = "";
  bool respostaInvalida = true;
  bool configurarVelocidade = false;
  bool configurarVolume = false;
  bool novaConfiguracao = false;

  double valor = 100;
  Color boxColor = const Color(0xFFC7C9FF);
  String speedOption = speeds.first;

  BoxDecoration styleBox() {
    return BoxDecoration(
      color: boxColor,
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
    );
  }

  TextStyle styleBoxTitle() {
    return GoogleFonts.inclusiveSans(
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        color: Color(0xFF373B8A),
      ),
    );
  }

  void dialogo() async {
    await voice.speek("Vamos configurar minha voz. O que deseja configurar? A velocidade com que eu falo ou o volume da minha voz?");
    await Future.delayed(Duration(seconds: 10));

    do {
      respostaInvalida = true;

      while (respostaInvalida) {
        await voice.hear();
        resposta = voice.resposta;

        if (resposta.compareTo("velocidade") == 0){
          configurarVelocidade = true;
          respostaInvalida = false;
        } else if (resposta.compareTo("volume") == 0) {
          configurarVolume = true;
          respostaInvalida= false;
        } else {
          await voice.speek("Hummm não te escutei direito, o que você quer configurar?");
          await Future.delayed(Duration(seconds: 5));
        }
      }

      respostaInvalida = true;

      if (configurarVelocidade) {
        await voice.speek("Vamos configurar a velocidade que eu falo. Você prefere que eu fale na velocidade 0,5X 1X ou 2X?");
        await Future.delayed(Duration(seconds: 10));

        while (respostaInvalida) {
          await voice.hear();
          resposta = voice.resposta;

          if (resposta.compareTo("0,5x") == 0||
            resposta.compareTo("0.5x") == 0||
            resposta.compareTo("zero , cincox") == 0) {

              voice.speed = 0.2;  
              respostaInvalida = false;
          } else if (resposta.compareTo("1x") == 0 || resposta.compareTo("um x") == 0) {
            voice.speed = 0.5;
            respostaInvalida= false;
          } else if (resposta.compareTo("2x") == 0 || resposta.compareTo("dois x") == 0) {
            voice.speed = 1.0;
            respostaInvalida= false;
          } else {
            await voice.speek("Hummm não te escutei direito, pode repetir de novo?");
            await Future.delayed(Duration(seconds: 5));
          }
        }
        configurarVelocidade = false;
      }

      if (configurarVolume) {
        await voice.speek("Vamos configurar a altura da minha voz. Você prefere que eu fale alto médio ou baixo?");
        await Future.delayed(Duration(seconds: 10));

        while (respostaInvalida) {
          await voice.hear();
          resposta = voice.resposta;

          if (resposta.compareTo("alto") == 0) {
            voice.volume =   1.0;
            respostaInvalida = false;
          } else if (resposta.compareTo("médio") == 0 || resposta.compareTo("medio") == 0) {
            voice.volume = 0.5;
            respostaInvalida= false;
          } else if (resposta.compareTo("baixo") == 0) {
            voice.volume = 0.2;
            respostaInvalida= false;
          } else {
            voice.speek("Hummm não te escutei direito, repete de novo?");
            await Future.delayed(Duration(seconds: 5));
          }
        }
        configurarVolume = false;
      }

      await voice.speek("Você deseja realizar mais alguma configuração?");
      await Future.delayed(Duration(seconds: 5));
      respostaInvalida = true;

      while (respostaInvalida) {
        await voice.hear();
        resposta = voice.resposta;

        if (resposta.compareTo("sim") == 0) {
          await voice.speek("E o que deseja configurar? A velocidade ou volume da minha voz?");
          await Future.delayed(Duration(seconds: 5));
          novaConfiguracao = true;
          respostaInvalida = false;
        } else if (resposta.compareTo("não") == 0) {
          respostaInvalida = false;
          novaConfiguracao = false;
        } else {
          await voice.speek("Hummm não te escutei direito, repete de novo?");
          await Future.delayed(Duration(seconds: 5));
        }
      }
    } while (novaConfiguracao);

    irUIMenu();
  }

  void irUIMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Menubar(index: 0)),
    );
  }

  bool dialogoNaoInicializado = true;

  @override
  Widget build(BuildContext context) {

    if(dialogoNaoInicializado) {
      dialogoNaoInicializado = false;
      dialogo();
    }

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 45, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: const Icon(FontAwesomeIcons.xmark),
                        color: const Color(0xFF373B8A),
                        iconSize: 30,
                        onPressed: () {
                          (
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Menubar(index: 0,)),
                            ),
                          );
                        }),
                  ],
                ),
              ),

              const Padding(padding: EdgeInsets.only(top: 50)),
              // Informa o titulo da pagina
              Text(
                "Configuração",
                textAlign: TextAlign.center,
                style: GoogleFonts.dosis(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                      fontSize: 40,
                      color: Color(0xFF5100FF)),
                ),
              ),

              // Gap entre elementos
              const SizedBox(
                height: 80,
              ),

              // Campo do volume
              Container(
                width: 0.8 * MediaQuery.of(context).size.width,
                // height: 0.2 * MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(
                    left: 30, top: 20, right: 30, bottom: 20),
                decoration: styleBox(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Volume', style: styleBoxTitle()),
                    Slider(
                        value: valor, //definir o valor inicial
                        min: 0,
                        max: 100,
                        divisions:
                            100, //define as divisoes entre o minimo e o maximo
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
                width: 0.8 * MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    left: 30, top: 20, right: 30, bottom: 20),
                decoration: styleBox(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Velocidade',
                      style: styleBoxTitle(),
                    ),
                    SizedBox(
                      width: 70,
                      child: DropdownButton<String>(
                        dropdownColor: const Color(0xFFb2b4ff),
                        // dropdownColor: Color.fromARGB(255, 221, 163, 255),
                        isExpanded: true,
                        value: speedOption,
                        icon: const Icon(FontAwesomeIcons.chevronDown),
                        iconSize: 15,
                        iconEnabledColor: const Color(0xFF373B8A),
                        iconDisabledColor: const Color(0xFFFAFAFA),
                        underline: Container(
                          color: const Color(0x00000000),
                        ),
                        elevation: 15,
                        borderRadius: BorderRadius.circular(10),
                        style: const TextStyle(
                            color: Color(0xFF373B8A),
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            speedOption = value!;
                          });
                        },
                        items: speeds
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
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
