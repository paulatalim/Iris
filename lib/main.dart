import 'package:flutter/material.dart';
import 'configuracao.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Iris',
    debugShowCheckedModeBanner: false,
    // theme: ThemeData(
    //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //   useMaterial3: true,
    // ),
    home: Configuracao(),
  ));
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Iris',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const Configuracao(),
//     );
//   }
// }
