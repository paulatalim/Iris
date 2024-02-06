import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../recurso_de_voz/speech_manager.dart';
// import '../provider/locale_provider.dart';
// import '../l10n/l10n.dart';
import 'menu.dart';

class Configuracao extends StatefulWidget {
  const Configuracao({super.key});

  @override
  State<Configuracao> createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {
  List<String> speeds = <String>['0.5x', '1.0x', '1.5x'];

  final Color _boxColor = const Color(0xFFC7C9FF);

  double _valorVolume = 100;

  late String _speedOption;
  late bool _ativarVoz;

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

  void _dialogo() async {
    String resposta = "";
    bool respostaInvalida = true;
    bool configurarVelocidade = false;
    bool configurarVolume = false;
    bool novaConfiguracao = false;

    await speech.speak("Vamos configurar minha voz. O que deseja configurar? A velocidade com que eu falo ou o volume da minha voz?");
    
    do {
      respostaInvalida = true;

      while (respostaInvalida) {
        resposta = await speech.listen();

        switch (resposta) {
          case "velocidade":
            configurarVelocidade = true;
            respostaInvalida = false;
            break;

          case "volume":
            configurarVolume = true;
            respostaInvalida= false;
            break;

          default:
            await speech.speak("Hummm não te escutei direito, o que você quer configurar?");
        }
      }

      respostaInvalida = true;

      if (configurarVelocidade) {
        await speech.speak("Vamos configurar a velocidade que eu falo. Você prefere que eu fale na velocidade 0,5X 1X ou 2X?");

        while (respostaInvalida) {
          resposta = await speech.listen();

          if (resposta.compareTo("0,5x") == 0||
            resposta.compareTo("0.5x") == 0||
            resposta.compareTo("zero , cincox") == 0) {

            // voice.speed = 0.2;  
            respostaInvalida = false;
          } else if (resposta.compareTo("1x") == 0 || resposta.compareTo("um x") == 0) {
            // voice.speed = 0.5;
            respostaInvalida= false;
          } else if (resposta.compareTo("2x") == 0 || resposta.compareTo("dois x") == 0) {
            // voice.speed = 1.0;
            respostaInvalida= false;
          } else {
            await speech.speak("Hummm não te escutei direito, pode repetir de novo?");
          }
        }
        configurarVelocidade = false;
      }

      if (configurarVolume) {
        await speech.speak("Vamos configurar a altura da minha voz. Você prefere que eu fale alto médio ou baixo?");

        while (respostaInvalida) {
          resposta = await speech.listen();

          switch (resposta) {
            case "alto":
              // voice.volume = 1.0;
              respostaInvalida = false;
              break;

            case "médio":
              // voice.volume = 0.5;
              respostaInvalida= false;
              break;

            case "baixo":
              // voice.volume = 0.2;
              respostaInvalida= false;
              break;

            default:
              await speech.speak("Hummm não te escutei direito, repete de novo?");
          }
        }
        configurarVolume = false;
      }

      await speech.speak("Você deseja realizar mais alguma configuração?");
      respostaInvalida = true;

      while (respostaInvalida) {
        resposta = await speech.listen();
        switch(resposta) {
          case "sim":
            await speech.speak("E o que deseja configurar? A velocidade ou volume da minha voz?");
            novaConfiguracao = true;
            respostaInvalida = false;
            break;

          case "não":
            respostaInvalida = false;
            novaConfiguracao = false;
            break;
            
          default:
            await speech.speak("Hummm não te escutei direito, repete de novo?");
        }
      }
    } while (novaConfiguracao);

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
      
    } while (respostaInvalida);
  }

  void _irUIMenu(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Menu(index: index,)),
    );
  }

  @override
  void initState() {
    super.initState();
    _speedOption= speeds[1];
    _ativarVoz = speech.controlarPorVoz;
    
    if(speech.controlarPorVoz) {
      _dialogo();
    }
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
                          });
                        }
                      ),
                    ],
                  ),
                ),

                // Gap entre elementos
                // const SizedBox(
                //   height: 30,
                // ),
          
                // // Compo do idioma
                // Container(
                //   width: 0.8 * MediaQuery.of(context).size.width,
                //   padding: const EdgeInsets.only(
                //       left: 30, top: 20, right: 30, bottom: 20),
                //   decoration: _styleBox(),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         AppLocalizations.of(context)!.idioma,
                //         style: _styleBoxTitle(),
                //       ),
                //       SizedBox(
                //         width: 110,
                //         child: DropdownButtonHideUnderline(
                //           child: DropdownButton(
                //             value: locale,
                //             icon: const Icon(FontAwesomeIcons.chevronDown),
                //             iconSize: 15,
                //             iconEnabledColor: const Color(0xFF373B8A),
                //             iconDisabledColor: const Color(0xFFFAFAFA),
                //             underline: Container(
                //             color: const Color(0x00000000),
                //           ),
                //           elevation: 15,
                //           borderRadius: BorderRadius.circular(10),
                //           style: const TextStyle(
                //               color: Color(0xFF373B8A),
                //               fontSize: 20,
                //               fontWeight: FontWeight.w500),
                //             items: L10n.all.map(
                //               (locale) {
                //                 final language = L10n.getLanguage(locale.languageCode);
          
                //                 return DropdownMenuItem(
                //                   value: locale,
                //                   onTap: () {
                //                     final provider = Provider.of<LocaleProvider>(context, listen: false);
          
                //                     provider.setLocale(locale);
                //                     provider.saveLocale(locale);
                //                   },
                //                   child: Center(
                //                     child: Text(
                //                       language,
                //                       style: const TextStyle(fontSize: 20),
                //                     ),
                //                   ),
                //                 );
                //               }
                //             ).toList(),
                //             onChanged: (_) {},
                //             )
                //         )
                //       ),
                //     ],
                //   ),
                // ),

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
                              // voice.volume = novoValorVolume / 100;
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