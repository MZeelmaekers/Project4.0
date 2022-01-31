import 'dart:convert';
import 'dart:io';

import 'package:azblob/azblob.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project40_mobile_app/apis/plant_api.dart';
import 'package:project40_mobile_app/apis/result_api.dart';
import 'package:project40_mobile_app/models/plant.dart';
import 'package:project40_mobile_app/models/result.dart';
import 'package:project40_mobile_app/pages/plant_detail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project40_mobile_app/global_vars.dart' as global;
import 'package:path/path.dart' as path;
import 'package:async/async.dart' as async;
import 'package:http/http.dart' as http;

class UploadPhotoPage extends StatefulWidget {
  const UploadPhotoPage({Key? key}) : super(key: key);

  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  AzureStorage azureStorage = AzureStorage.parse(
      'DefaultEndpointsProtocol=https;AccountName=storagemainfotosplanten;AccountKey=YHIqjHCcXi8IO3DabS+N1lRzrBoltBaDDofu9vJmMo2tMQghoHMQ8fKT/GXVD0Q569EW8pfuJVqv7CjVkPreVA==;EndpointSuffix=core.windows.net');
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload picture"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(10.0)),
              const Text(
                "Upload a picture from your gallery.",
                style: TextStyle(
                  fontSize: 20.0,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Padding(padding: EdgeInsets.all(10.0)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(40, 60) // put the width and height you want
                    ),
                child: const Icon(
                  Icons.upload,
                  size: 36.0,
                  semanticLabel: 'Upload image from gallery button',
                ),
                onPressed: _openImagePicker,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Implementing the image picker

  Future<Result> _getResult(File imageFile) async {
    // open a bytestream
    var stream =
        new http.ByteStream(async.DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("https://ai-api-michielvdz.cloud.okteto.net/result");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: path.basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    
      var res = response.stream.bytesToString().then((responseStream){
      var json = jsonDecode(responseStream);
      Result res = Result(
        id: 0,
        prediction: json['week'],
        accuracy: double.parse(json['accuracy']) * 100,
        createdAt: '');
        return res;
    });
 
        return ResultApi.createResult(await res);
  }

  Future<int> _createPlant(imageName, resultId) {
    Plant plant = Plant(
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

  

  _asyncFileUpload(XFile image) async {
    // Upload the image to the Blob storage on Azure => Bodybytes sends the data of the image
    await azureStorage.putBlob('/botanic/' + image.name,
        bodyBytes: await image.readAsBytes());

    // Wait for a result page from the AI API
    Result newResult = await _getResult(File(image.path));

    // Create a plant object in the database
    int plantId = await _createPlant(image.name, newResult.id);

    // Go to the Result detail page of the newly created object
    _navigateToPlantDetailPage(plantId);
  }

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _asyncFileUpload(pickedImage);
    }
  }
}
