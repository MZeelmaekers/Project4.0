import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:project40_mobile_app/pages/login.dart';
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
      appBar: AppBar(title: Text('home-title'.i18n())),
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            Text(
              'home-app_name'.i18n(),
              textAlign: TextAlign.center,
              style: const TextStyle(
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
                  fixedSize:
                      const Size(200, 60) // put the width and height you want
                  ),
              onPressed: () {
                _navigateToUpload();
              },
              child: Text(
                'home-button_upload'.i18n(),
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                  fixedSize:
                      const Size(200, 60) // put the width and height you want
                  ),
              onPressed: () {
                _navigateToPhoto();
              },
              child: Text(
                'home-button_camera'.i18n(),
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                  fixedSize:
                      const Size(200, 60) // put the width and height you want
                  ),
              onPressed: () {
                _navigateToResults();
              },
              child: Text(
                'home-button_results'.i18n(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize:
                      const Size(200, 60) // put the width and height you want
                  ),
              onPressed: () {
                _logout();
              },
              child: Text(
                'home-button_logout'.i18n(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/vito_logo.png",
                  width: 250,
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset(
                  "assets/images/tm_standaardlogo_web.png",
                  width: 100,
                ),
                Image.asset(
                  "assets/images/botanic_logo.png",
                  width: 100,
                )
              ],
            )
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
