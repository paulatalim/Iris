import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../recurso_de_voz/speech_manager.dart';
import 'menu.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  /// Estiliza campo integrantes
  TextStyle integranteStyle() {
    return GoogleFonts.inclusiveSans(
      textStyle: const TextStyle(
        color: Color.fromARGB(255, 30, 32, 75),
        fontSize: 20,
      ),
    );
  }

  // Estiliza subtitulos da pagina
  TextStyle subtitle() {
    return GoogleFonts.inclusiveSans(
      textStyle: const TextStyle(
        color: Color.fromARGB(255, 30, 32, 75),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }

  void _irUIMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const Menu()),
    );
  }

  void _dialogo() async {
    await speech.speak("Let me introduce myself, I'm Iris, and I was developed with the aim of improving the quality of life for the visually impaired"
    "providing a range of health-related services and body measurements, including body mass monitoring, among other essential resources for your daily life.");
    _irUIMenu();
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
      body: SingleChildScrollView(
        child: Container(
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
          // Titulo
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          if(!speech.controlarPorVoz) {
                            _irUIMenu();
                          }
                          
                        }),
                  ],
                ),
              ),
              Container(
                // decoration: const BoxDecoration(color: Colors.blue),
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Iris',
                      style: GoogleFonts.dosis(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                            fontSize: 100,
                            color: Color(0xFF5100FF)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Image.asset(
                      'assets/icon/logo.png',
                      width: 130,
                      // height: 100,
                    ),
                    const SizedBox(height: 45),
                    Text(
                      AppLocalizations.of(context)!.infoApp,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inclusiveSans(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 30, 32, 75),
                          fontSize: 21,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 6.0),
                          Text(
                            AppLocalizations.of(context)!.members,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inclusiveSans(
                                textStyle: subtitle()),
                          ),
                          const SizedBox(height: 6.0),

                          // Espaço entre os textos
                          Text(
                            'Ana Beatriz',
                            textAlign: TextAlign.center,
                            style: integranteStyle(),
                          ),

                          const SizedBox(height: 3.0), // Espaço entre os textos

                          Text(
                            'Mariana Aram',
                            textAlign: TextAlign.center,
                            style: integranteStyle(),
                          ),

                          const SizedBox(height: 3.0), // Espaço entre os textos

                          Text(
                            'Paula Talim',
                            textAlign: TextAlign.center,
                            style: integranteStyle(),
                          ),

                          const SizedBox(height: 3.0), // Espaço entre os textos

                          Text(
                            'Pedro Mafra',
                            textAlign: TextAlign.center,
                            style: integranteStyle(),
                          ),

                          const SizedBox(height: 3.0), // Espaço entre os textos

                          Text(
                            'Yago Garzon',
                            textAlign: TextAlign.center,
                            style: integranteStyle(),
                          ),

                          const SizedBox(
                              height: 20.0), // Espaço entre os textos

                          Text(
                            AppLocalizations.of(context)!.advisor,
                            textAlign: TextAlign.center,
                            style: subtitle(),
                          ),

                          const SizedBox(height: 8.0), // Espaço entre os textos
                          Text(
                            'Ilo Riveiro',
                            textAlign: TextAlign.center,
                            style: integranteStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              Container(
                  padding: const EdgeInsets.only(top: 18.0, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.contact,
                        textAlign: TextAlign.center,
                        style: subtitle(),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 30, 32, 75),
                        ),
                        title: Text(
                          'PUC Minas',
                          style: GoogleFonts.inclusiveSans(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 30, 32, 75),
                              fontSize: 18,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          'Coração Eucarístico',
                          style: GoogleFonts.inclusiveSans(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 30, 32, 75),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              const Padding(padding: EdgeInsets.only(bottom: 40)),
            ],
          ),
        ),
      ),
    );
  }
}
