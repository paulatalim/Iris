import 'package:flutter/material.dart';

void main() {
  runApp(Login());
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primaryColor: Colors.lightBlueAccent,
      ),
      home: TelaLogin(),
    );
  }
}

class TelaLogin extends StatelessWidget {
  @override
  WidgetBuild(BuildContext context) {
    final usuario = TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: "Nome ou E-mail"
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Controle"),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              children: <Widget>[Text('a  ')],
            ),
        ),
      ),
    ));
  }
}