import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project40_mobile_app/pages/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras[0];

  runApp(AnalyserApp(camera: firstCamera));
}

class AnalyserApp extends StatelessWidget {
  AnalyserApp({
    Key? key,
    required this.camera,
  }) : super(key: key);
  final CameraDescription camera;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Botanic Analyser App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(camera: camera,),
    );
  }
}