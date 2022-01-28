import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project40_mobile_app/pages/login_page.dart';
import 'package:project40_mobile_app/pages/plant_list.dart';
import 'package:project40_mobile_app/pages/photo.dart';
import 'package:project40_mobile_app/global_vars.dart' as global;
import 'package:project40_mobile_app/pages/upload_photo.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            const Text(
              "VITO Analyser app",
              style: TextStyle(
                fontSize: 40.0,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(30, 50) // put the width and height you want
                  ),
              onPressed: () {
                _navigateToUpload();
              },
              child: const Text(
                "Upload picture",
                style: TextStyle(
                  fontSize: 20.0,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(30, 50) // put the width and height you want
                  ),
              onPressed: () {
                _navigateToPhoto();
              },
              child: const Text(
                "Take picture",
                style: TextStyle(
                  fontSize: 20.0,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(30, 50) // put the width and height you want
                  ),
              onPressed: () {
                _navigateToResults();
              },
              child: const Text(
                "Show Results",
                style: TextStyle(
                  fontSize: 20.0,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(30, 50) // put the width and height you want
                  ),
              onPressed: () {
                _logout();
              },
              child: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20.0,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToUpload() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UploadPhotoPage()),
    );
  }

  void _navigateToResults() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlantListPage()),
    );
  }

  void _logout() async {
    global.userToken = "";
    global.userId = 0;

    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void _navigateToPhoto() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras[0];

    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TakePictureScreen(
                camera: firstCamera,
              )),
    );
  }
}
