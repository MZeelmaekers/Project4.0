import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:azblob/azblob.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:project40_mobile_app/apis/plant_api.dart';
import 'package:project40_mobile_app/apis/result_api.dart';
import 'package:project40_mobile_app/models/plant.dart';
import 'package:project40_mobile_app/models/result.dart';
import 'package:project40_mobile_app/pages/plant_detail.dart';
import 'package:project40_mobile_app/pages/plant_list.dart';

import 'package:project40_mobile_app/global_vars.dart' as global;

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(70, 70),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(180.0),
                        ),
                      ),

                      // Provide an onPressed callback.
                      onPressed: () async {
                        // Take the Picture in a try / catch block. If anything goes wrong,
                        // catch the error.
                        try {
                          // Ensure that the camera is initialized.
                          await _initializeControllerFuture;

                          // Setup Azurestorage
                          var azureStorage = AzureStorage.parse(
                              'DefaultEndpointsProtocol=https;AccountName=storagemainfotosplanten;AccountKey=YHIqjHCcXi8IO3DabS+N1lRzrBoltBaDDofu9vJmMo2tMQghoHMQ8fKT/GXVD0Q569EW8pfuJVqv7CjVkPreVA==;EndpointSuffix=core.windows.net');
                          // Attempt to take a picture and then get the location
                          // where the image file is saved.
                          final image = await _controller.takePicture();

                          // Upload the image to the Blob storage on Azure => Bodybytes sends the data of the image
                          await azureStorage.putBlob('/botanic/' + image.name,
                              bodyBytes: await image.readAsBytes());

                          // Wait for a result page from the AI API
                          Result newResult = await _getResult();

                          // Create a plant object in the database
                          int plantId =
                              await _createPlant(image.name, newResult.id);

                          // Go to the Result detail page of the newly created object
                          _navigateToPlantDetailPage(plantId);
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
                    ),
                  )
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

  Future<Result> _getResult() async {
    Result result =
        new Result(accuracy: 78.12, prediction: 'WEEK1', createdAt: '', id: 0);

    return ResultApi.createResult(result);
  }

  Future<int> _createPlant(imageName, resultId) {
    Plant plant = new Plant(
        id: 0,
        location: "18.9187,71.192",
        fotoPath: imageName,
        userId: global.userId,
        createdAt: DateTime.now().toString(),
        resultId: resultId);

    return PlantApi.createPlant(plant);
  }

  void _navigateToPlantDetailPage(int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlantDetailPage(id: id)),
    );
  }
}
