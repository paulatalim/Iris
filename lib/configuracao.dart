import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Configuracao extends StatefulWidget {
  const Configuracao({super.key});

  @override
  State<Configuracao> createState() => _ConfiguracaoState();
}

List<String> speeds = <String>['1.0x', '2.0x', '3.0x'];

class _ConfiguracaoState extends State<Configuracao> {
  double valor = 50;
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
    return const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        color: Color(0xFF373B8A));
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 100)),

              // Informa o titulo da pagina
              Text(
                "Configuração",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserratAlternates(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 33,
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
                    Text('Volume',
                        style: GoogleFonts.inclusiveSans(
                            textStyle: styleBoxTitle())),
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
                      style:
                          GoogleFonts.inclusiveSans(textStyle: styleBoxTitle()),
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
