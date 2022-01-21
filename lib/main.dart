import 'package:flutter/material.dart';
import 'package:project40_mobile_app/pages/home.dart';

void main() {
  runApp(AnalyserApp());
}

class AnalyserApp extends StatelessWidget {
  AnalyserApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Botanic Analyser App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}
