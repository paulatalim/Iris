import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color minhaCorPersonalizada = Color(0xFF6A5ACD); // Lavanda
    Color minhaCorEscura = Color(0xFF483D8B); // Lavanda Escuro
    Color corLavandaClaro =
    Color(0xFFB49CDC); // Substituído corClara por corLavandaClaro

    return MaterialApp(
      title: 'Iris',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple, // Cor primária
          accentColor: minhaCorPersonalizada, // Cor de destaque personalizada
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'About us',
        corLavanda: minhaCorPersonalizada,
        corLavandaEscura: minhaCorEscura,
        corLavandaClaro: corLavandaClaro,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Color corLavanda;
  final Color corLavandaEscura;
  final Color corLavandaClaro;
  final String title;

  MyHomePage({
    required this.corLavanda,
    required this.corLavandaEscura,
    required this.corLavandaClaro,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),git 
        backgroundColor: corLavandaEscura,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Saúde para cegos',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: 8),
                  Image.asset(
                    'lib/irislogo.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
            ),
            Container(
              width: screenWidth,
              padding: EdgeInsets.all(8),
              child: Text(
                'Este aplicativo foi desenvolvido com o objetivo de melhorar a qualidade de vida dos deficientes auditivos, '
                    'fornecendo uma variedade de serviços relacionados à saúde e medidas corporais, incluindo o '
                    'acompanhamento da massa corporal, entre outros recursos essenciais para o seu dia a dia.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 6.0),
                  Text(
                    'Integrantes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6.0), // Espaço entre os textos
                  Text(
                    'Ana Beatriz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 3.0), // Espaço entre os textos
                  Text(
                    'Mariana Aram',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 3.0), // Espaço entre os textos
                  Text(
                    'Paula Talim',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 3.0), // Espaço entre os textos
                  Text(
                    'Pedro Mafra',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 3.0), // Espaço entre os textos
                  Text(
                    'Yago Garzon',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 11.0), // Espaço entre os textos
                  Text(
                    'Orientador',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5.0), // Espaço entre os textos
                  Text(
                    'Ilo Riveiro',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 10.0), // Espaço entre os textos
            Container(
                padding: EdgeInsets.only(top: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fale Conosco:',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6!.merge(
                        TextStyle(
                          fontSize: 21.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text('PUC Minas'),
                      subtitle: Text('Coração Eucarístico'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('...'),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('...'),
                    ),
                  ],
                )
            ),
            Container(
              width: screenWidth,
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Veja nosso projeto:',
                    style: Theme.of(context).textTheme.headline6!.merge(
                      TextStyle(
                        fontSize: 21.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    leading: Icon(Icons.link),
                    title: Text('GitHub'),
                    onTap: () => launchUrl(Uri.parse('https://github.com/paulatalim/Iris_aplicativo_saude_cegos')),
                  ),
                ],
              ),
            )

          ],

        ),
      ),
    );
  }

  launchUrl(Uri parse) {}
}

