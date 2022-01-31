import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:azblob/azblob.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:project40_mobile_app/apis/plant_api.dart';
import 'package:project40_mobile_app/apis/result_api.dart';
import 'package:project40_mobile_app/models/plant.dart';
import 'package:project40_mobile_app/models/result.dart';
import 'package:project40_mobile_app/pages/photo_detail.dart';
import 'package:project40_mobile_app/pages/plant_detail.dart';
import 'package:project40_mobile_app/global_vars.dart' as global;
import 'package:path/path.dart' as path;
import 'package:async/async.dart' as async;
import 'package:http/http.dart' as http;

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  var value;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Center(
              child: Column(
                children: [
                  CameraPreview(_controller),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(70, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(180.0),
                          ),
                        ),

                      // Provide an onPressed callback.
                      onPressed: () async {
                        // Take the Picture in a try / catch block. If anything goes wrong,
                        // catch the error.
                        try {
                          // Ensure that the camera is initialized.
                          await _initializeControllerFuture;

                          // Attempt to take a picture and then get the location
                          // where the image file is saved.
                          final image = await _controller.takePicture();
                          
                          _navigateToPhotoDetailPage(image);
                        } on AzureStorageException catch (ex) {
                          // Error of Azure
                          print(ex.message);
                        } catch (e) {
                          // If an error occurs, log the error to the console.
                          print(e);
                        }
                      },

                      child: const Icon(
                        Icons.camera_alt,
                        size: 36,
                      ),
                    ],
                  ))
                ],
              ),
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _navigateToPhotoDetailPage(XFile image) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhotoDetailPage(image: image)));
  }

  
}
