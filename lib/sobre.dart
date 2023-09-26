import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  // final Color corLavanda;
  // final Color corLavandaEscura;
  // final Color corLavandaClaro;
  // final String title;

  // Sobre({
  //   required this.corLavanda,
  //   required this.corLavandaEscura,
  //   required this.corLavandaClaro,
  //   required this.title,
  // });

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  TextStyle integranteStyle() {
    return const TextStyle(
      color: Color(0xFF373B8A),
      fontSize: 20,
    );
  }

  TextStyle subtitle() {
    return const TextStyle(
        color: Color(0xFF373B8A),
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 2);
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
              const Padding(padding: EdgeInsets.only(top: 100)),
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
                      'assets/images/irislogo.png',
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
                            style: subtitle(),
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
                              height: 11.0), // Espaço entre os textos

                          Text(
                            'Orientador',
                            textAlign: TextAlign.center,
                            style: subtitle(),
                          ),

                          const SizedBox(height: 5.0), // Espaço entre os textos
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
              const SizedBox(width: 10.0),
              Container(
                  padding: const EdgeInsets.only(top: 18.0, left: 30),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fale Conosco:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 21.0,
                        ),
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text('PUC Minas'),
                        subtitle: Text('Coração Eucarístico'),
                      ),
                      // ListTile(
                      //   leading: Icon(Icons.phone),
                      //   title: Text('...'),
                      // ),
                      // ListTile(
                      //   leading: Icon(Icons.email),
                      //   title: Text('...'),
                      // ),
                    ],
                  )),
              Container(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 30, bottom: 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Veja nosso projeto:',
                      style: TextStyle(
                        fontSize: 21.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: const Icon(Icons.link),
                      title: const Text('GitHub'),
                      onTap: () => launchUrl(Uri.parse(
                          'https://github.com/paulatalim/Iris_aplicativo_saude_cegos')),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  launchUrl(Uri parse) {}
}