import 'package:flutter/material.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
// import 'package:google_fonts/google_fonts.dart';

class Configuracao extends StatefulWidget {
  const Configuracao({super.key});

  @override
  State<Configuracao> createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {
  double valor = 50;

  List<String> pokemons = ['1.0 X', '2.0 X', '3.0 X'];
  final pokemonDropdownController = DropdownController();
  final listDropdownController = DropdownController();

  List<CoolDropdownItem<String>> pokemonDropdownItems = [];

  @override
  void initState() {
    for (var i = 0; i < pokemons.length; i++) {
      pokemonDropdownItems.add(
        CoolDropdownItem<String>(
          label: pokemons[i],
          // icon: const Icon(Icons.home),
          value: pokemons[i],
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.orange])),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 100)),

              // Informa o titulo da pagina
              const Text(
                "Configuração",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    color: Color(0xFF5100FF)),
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
                decoration: BoxDecoration(
                  color: const Color(0xFFA99DE6),
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
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Volume'),
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
                // height: 0.1 * MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(
                    left: 30, top: 30, right: 30, bottom: 30),
                decoration: BoxDecoration(
                  color: const Color(0xFFA99DE6),
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
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Velocidade'),
                    WillPopScope(
                      onWillPop: () async {
                        if (pokemonDropdownController.isOpen) {
                          pokemonDropdownController.close();
                          return Future.value(false);
                        } else {
                          return Future.value(true);
                        }
                      },
                      child: CoolDropdown<String>(
                        controller: pokemonDropdownController,
                        dropdownList: pokemonDropdownItems,
                        defaultItem: null,
                        onChange: (value) async {
                          if (pokemonDropdownController.isError) {
                            await pokemonDropdownController.resetError();
                          }
                        },
                        onOpen: (value) {},
                        resultOptions: const ResultOptions(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: 80,
                          render: ResultRender.all,
                          placeholder: '1.0 X',
                          isMarquee: true,
                        ),
                        dropdownOptions: const DropdownOptions(
                            top: 20,
                            height: 400,
                            gap: DropdownGap.all(5),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            align: DropdownAlign.left,
                            animationType: DropdownAnimationType.size),
                        dropdownTriangleOptions: const DropdownTriangleOptions(
                          width: 20,
                          height: 30,
                          align: DropdownTriangleAlign.left,
                          borderRadius: 3,
                          left: 20,
                        ),
                        dropdownItemOptions: const DropdownItemOptions(
                          isMarquee: true,
                          mainAxisAlignment: MainAxisAlignment.start,
                          render: DropdownItemRender.all,
                          height: 50,
                        ),
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
