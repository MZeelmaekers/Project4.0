import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project40_mobile_app/pages/login_page.dart';

const storage = FlutterSecureStorage();

void main() {
  runApp(AnalyserApp());
}

class AnalyserApp extends StatelessWidget {
  const AnalyserApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Botanic Analyser App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(),
    );
  }
}
