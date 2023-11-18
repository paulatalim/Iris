import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'menu.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  TextStyle integranteStyle() {
    return GoogleFonts.inclusiveSans(
      textStyle: const TextStyle(
        color: Color(0xFF373B8A),
        fontSize: 20,
      ),
    );
  }

  TextStyle subtitle() {
    return GoogleFonts.inclusiveSans(
      textStyle: const TextStyle(
        color: Color(0xFF373B8A),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
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
                          (
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Menubar()),
                            ),
                          );
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
                      'assets/icon/logoIcone.png',
                      width: 130,
                      // height: 100,
                    ),
                    const SizedBox(height: 45),
                    Text(
                      'Este aplicativo foi desenvolvido com o objetivo de melhorar a qualidade de vida dos deficientes auditivos, '
                      'fornecendo uma variedade de serviços relacionados à saúde e medidas corporais, incluindo o '
                      'acompanhamento da massa corporal, entre outros recursos essenciais para o seu dia a dia.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inclusiveSans(
                        textStyle: const TextStyle(
                          color: Color(0xFF373B8A),
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
                            'Integrantes',
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
                            'Orientador',
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
                        'Fale Conosco:',
                        textAlign: TextAlign.center,
                        style: subtitle(),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(
                          Icons.location_on,
                          color: Color(0xFF373B8A),
                        ),
                        title: Text(
                          'PUC Minas',
                          style: GoogleFonts.inclusiveSans(
                            textStyle: const TextStyle(
                              color: Color(0xFF373B8A),
                              fontSize: 18,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          'Coração Eucarístico',
                          style: GoogleFonts.inclusiveSans(
                            textStyle: const TextStyle(
                              color: Color(0xFF373B8A),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              // Container(
              //   padding: const EdgeInsets.only(top: 10.0, left: 30),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Veja nosso projeto:',
              //         style: GoogleFonts.inclusiveSans(textStyle: subtitle()),
              //       ),
              //       const SizedBox(height: 8),
              //       ListTile(
              //         leading: const Icon(
              //           Icons.link,
              //           color: Color(0xFF373B8A),
              //         ),
              //         title: Text(
              //           'GitHub',
              //           style: GoogleFonts.inclusiveSans(
              //             textStyle: const TextStyle(
              //               color: Color(0xFF373B8A),
              //               fontSize: 18,
              //             ),
              //           ),
              //         ),
              //         onTap: () => launchUrl(Uri.parse(
              //             'https://github.com/paulatalim/Iris_aplicativo_saude_cegos')),
              //       ),
              //     ],
              //   ),
              // )
              const Padding(padding: EdgeInsets.only(bottom: 40)),
            ],
          ),
        ),
      ),
    );
  }

  launchUrl(Uri parse) {}
}
