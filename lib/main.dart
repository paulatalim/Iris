import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iris',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double valor = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Configurações'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Informa o titulo da pagina
            const Text(
              "Configuração",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Calibri',
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Colors.red),
            ),

            // Gap entre elementos
            const SizedBox(
              height: 80,
            ),

            // Campo do volume
            Container(
              color: Colors.blue,
              width: 800,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Volume'),
                  Slider(
                      value: valor, //definir o valor inicial
                      min: 0,
                      max: 100,
                      label: 'Volume', //label dinamico
                      divisions:
                          10, //define as divisoes entre o minimo e o maximo
                      activeColor: Colors.red,
                      inactiveColor: Colors.black12,
                      onChanged: (double novoValor) {
                        setState(() {
                          valor = novoValor;
                          // label = "seleção: " + novoValor.toString();
                        });
                      }),
                ],
              ),
            ),

            // Gap entre elementos
            const SizedBox(
              height: 80,
            ),

            // Compo da velocidade
            Container(
              color: Colors.blue,
              width: 900,
              height: 300,
              padding: const EdgeInsets.all(100.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Velocidade'),
                  Text('0'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
