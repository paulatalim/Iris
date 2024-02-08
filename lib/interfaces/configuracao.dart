import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:iris_app/interfaces/loading.dart';

import '../recurso_de_voz/speech_manager.dart';
// import '../provider/locale_provider.dart';
// import '../l10n/l10n.dart';
// import 'menu.dart';
// import 'loading.dart';

class Configuracao extends StatefulWidget {
  const Configuracao({super.key});

  @override
  State<Configuracao> createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {
  List<String> speeds = <String>['0.5x', '1.0x', '1.5x', '2.0x', '3.0x'];

  final Color _boxColor = const Color(0xFFC7C9FF);

  double _valorVolume = 100;

  late String _speedOption;
  late bool _ativarVoz;

  bool _isRunning = true;
  late bool configVoz;
  late int configVolume;

  /// Estiliza os cards das configuracoes
  BoxDecoration _styleBox() {
    return BoxDecoration(
      color: _boxColor,
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

  /// Estiliza o texto do item das configuracoes
  TextStyle _styleBoxTitle() {
    return GoogleFonts.inclusiveSans(
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        color: Color(0xFF373B8A),
      ),
    );
  }

  void _atualizarConfiguracoes() async {
    while(_isRunning) {
      setState(() {
        _ativarVoz = speech.controlarPorVoz ?? true;
        _valorVolume = speech.volume;

        for (int i = 0; i < speeds.length; i++) {
          if (speeds[i] == "${speech.speed.toString()}x") {
            _speedOption = speeds[i];
            break;
          }
        }
      });

      if(!_ativarVoz) {
        break;
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void _dialogo() async {
    String resposta = "";
    bool respostaInvalida = true;
    bool configurarVelocidade = false;
    bool configurarVolume = false;
    bool controleVoz = false;
    bool novaConfiguracao = false;

    await speech.speak("Let's set up my voice. What would you like to adjust? The speed or the volume of my voice? Or disable voice control?");
    
    do {
      respostaInvalida = true;

      while (respostaInvalida && speech.controlarPorVoz) {
        resposta = await speech.listen();

        switch (resposta) {
          case "disable voice control":
          case "voice control":
            respostaInvalida = false;
            controleVoz = true;
            break;

          case "speed":
            configurarVelocidade = true;
            respostaInvalida = false;
            break;
          case "the speed":
            configurarVelocidade = true;
            respostaInvalida = false;
            break;

          case "the volume":
            configurarVolume = true;
            respostaInvalida= false;
            break;
           case "volume":
            configurarVolume = true;
            respostaInvalida= false;
            break;

          default:
            await speech.speak("Hmm, I didn't hear you properly, what do you want to configure?");
        }
      }

      respostaInvalida = true;

      if (controleVoz && speech.controlarPorVoz) {
        await speech.speak("Do you want to disable voice control?");

        while (respostaInvalida && speech.controlarPorVoz) {
          resposta = await speech.listen();

          switch (resposta) {
            case "yes":
              speech.controlarPorVoz = false;
              _ativarVoz = false;
              controleVoz = false;
              respostaInvalida = false;
              break;

            case "no":
              respostaInvalida = false;
              break;

            default:
              await speech.speak("Hmmm I didn't hear you right, can you repeat that again?");
          }
        }

        controleVoz = false;
      }
      
      if (configurarVelocidade && speech.controlarPorVoz) {
        await speech.speak("Let's adjust the speed. Do you prefer me to speak at 0.5X, 1X, 2X, 3X speed?");

        while (respostaInvalida && speech.controlarPorVoz) {
          resposta = await speech.listen();

          if (resposta.compareTo("0,5x") == 0||
            resposta.compareTo("0.5x") == 0||
            resposta.compareTo("zero . fivex") == 0) {

            speech.speed = 0.5;
            respostaInvalida = false;
          
          } else if (resposta.compareTo("1x") == 0 || resposta.compareTo("one x") == 0 || resposta == '1' || resposta == "one") {
            speech.speed = 1.0;
            respostaInvalida= false;
          
          } else if (resposta.compareTo("2x") == 0 || resposta.compareTo("two x") == 0 || resposta == "2" || resposta == "two") {
            speech.speed = 2.0;
            respostaInvalida= false;
          
          } else if (resposta == "3" || resposta == "three"|| resposta == "3x" || resposta == "three x") {
            speech.speed = 3.0;
            respostaInvalida= false;
          
          } else {
            await speech.speak("Hmm, I didn't hear you. Can you repeat that again?");
          }
        }
        configurarVelocidade = false;
      }

      if (configurarVolume && speech.controlarPorVoz) {
        await speech.speak("Let's adjust the volume. Do you prefer me to speak in a high, medium, or low volume?");

        while (respostaInvalida && speech.controlarPorVoz) {
          resposta = await speech.listen();

          switch (resposta) {
            case "high":
              speech.volume = 100;
              _valorVolume = 100;
              respostaInvalida = false;
              break;

            case "medium":
              speech.volume = 50;
              _valorVolume = 50;
              respostaInvalida= false;
              break;

            case "low":
              speech.volume = 20;
              _valorVolume = 20;
              respostaInvalida= false;
              break;

            default:
              await speech.speak("Hmm, I didn't hear you. Can you repeat that again?");
          }
        }
        configurarVolume = false;
      }

      if (speech.controlarPorVoz) {
        await speech.speak("Do you want to perform any further configuration?");
        respostaInvalida = true;
      }

      while (respostaInvalida && speech.controlarPorVoz) {
        resposta = await speech.listen();
        switch(resposta) {
          case "yes":
            await speech.speak("And what do you want to configure? Voice control? The speed or volume of my voice?");
            novaConfiguracao = true;
            respostaInvalida = false;
            break;

          case "no":
            respostaInvalida = false;
            novaConfiguracao = false;
            break;
            
          default:
            await speech.speak("Hmmm I didn't hear you right, repeat that again?");
        }
      }
    } while (novaConfiguracao && speech.controlarPorVoz);

    if (speech.controlarPorVoz) {
      await speech.speak("Which section do you want to go to now?");
      respostaInvalida = true;
    }
      
    while (respostaInvalida && speech.controlarPorVoz) {
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
          await speech.speak("You are already in this section, tell me another section. If you are unsure which option you want, choose the menu option. So which section do you want to go to now?");
          respostaInvalida = false;
          break;

        case "information":
          _irUIMenu(2);
          respostaInvalida = false;
          break;

        default:
          await speech.speak("Hmm, I didn't hear you clearly. What do you want me to measure?");
      }
    } 
  }

  void _irUIMenu(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoadScreen(index: index))
    );
  }

  @override
  void initState() {
    super.initState();
    _speedOption= speeds[1];
    _valorVolume = 100;
    _isRunning = true;
    
    if(speech.controlarPorVoz ?? true) {
      _dialogo();
    }

    _atualizarConfiguracoes();
  }

  @override
  void dispose() {
    super.dispose();
    _isRunning = false;
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<LocaleProvider>(context);
    // final locale = provider.locale;

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
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Container(
                //   padding: const EdgeInsets.only(top: 45, right: 20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     children: [
                //       IconButton(
                //           icon: const Icon(FontAwesomeIcons.xmark),
                //           color: const Color(0xFF373B8A),
                //           iconSize: 30,
                //           onPressed: () => _irUIMenu()
                //       ),
                //     ],
                //   ),
                // ),
          
                const Padding(padding: EdgeInsets.only(top: 50)),
                // Informa o titulo da pagina
                Text(
                  AppLocalizations.of(context)!.settings,
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

                SizedBox(
                  width: 0.7 * MediaQuery.of(context).size.width,
                  child: Text(
                    AppLocalizations.of(context)!.general,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.inclusiveSans(
                      textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: Color(0xFF373B8A),
                      ),
                    )
                  ),
                ),
          
                // Gap entre elementos
                const SizedBox(
                  height: 30,
                ),

                // Campo de ativação de voz
                Container(
                  width: 0.8 * MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                      left: 30, top: 20, right: 30, bottom: 20),
                  decoration: _styleBox(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Voice control",
                        style: _styleBoxTitle(),
                      ),
                      Switch(
                        value: _ativarVoz,
                        onChanged: (bool valor){
                          setState(() {
                            _ativarVoz = valor;
                            speech.controlarPorVoz = _ativarVoz;
                            if(valor) {
                              _dialogo();
                            }
                          });
                        }
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
          
                SizedBox(
                  width: 0.7 * MediaQuery.of(context).size.width,
                  child: Text(
                    AppLocalizations.of(context)!.voice,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.inclusiveSans(
                      textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: Color(0xFF373B8A),
                      ),
                    )
                  ),
                ),
          
                // Gap entre elementos
                const SizedBox(
                  height: 30,
                ),
          
                // Campo do volume
                Container(
                  width: 0.8 * MediaQuery.of(context).size.width,
                  // height: 0.2 * MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(
                      left: 30, top: 20, right: 30, bottom: 20),
                  decoration: _styleBox(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.volume, 
                        style: _styleBoxTitle()
                      ),
                      Slider(
                          value: _valorVolume, //definir o _valorVolume inicial
                          min: 0,
                          max: 100,
                          divisions:
                              100, //define as divisoes entre o minimo e o maximo
                          activeColor: const Color(0xFF5100FF),
                          inactiveColor: Colors.black12,
                          onChanged: (double novoValorVolume) {
                            setState(() {
                              _valorVolume = novoValorVolume;
                              speech.volume = novoValorVolume;
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
                  decoration: _styleBox(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.speed,
                        style: _styleBoxTitle(),
                      ),
                      SizedBox(
                        width: 70,
                        child: DropdownButton<String>(
                          dropdownColor: const Color.fromARGB(255, 255, 255, 255),
                          isExpanded: true,
                          value: _speedOption,
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
                              _speedOption = value!;
                              speech.speed = double.parse(_speedOption.replaceAll("x", ""));
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

                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}