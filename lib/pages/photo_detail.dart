import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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
import 'package:project40_mobile_app/global_vars.dart' as global;
import 'package:path/path.dart' as path;
import 'package:async/async.dart' as async;
import 'package:http/http.dart' as http;

class PhotoDetailPage extends StatefulWidget {
  XFile image;
  PhotoDetailPage({Key? key, required this.image}) : super(key: key);

  @override
  _PhotoDetailPageState createState() => _PhotoDetailPageState();
}

class _PhotoDetailPageState extends State<PhotoDetailPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController fieldNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Photo details")),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Center(
                child: FutureBuilder<Uint8List>(
                  future: _getImage(widget.image),
                  builder: (BuildContext context,
                      AsyncSnapshot<Uint8List> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Image.memory(
                        snapshot.data!,
                        height: 400.0,
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
              ),
              const Text(
                "Plant name",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Plant name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
              ),
              const Text(
                "Field name",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              TextField(
                controller: fieldNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Field description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onCancel,
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 20.0,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                              30, 50) // put the width and height you want
                          ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onSave,
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 20.0,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                              30, 50) // put the width and height you want
                          ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _onCancel() async {
    Navigator.pop(context);
  }

  void _onSave() async {
    XFile image = widget.image;
    // Setup Azurestorage
    var azureStorage = AzureStorage.parse(
        'DefaultEndpointsProtocol=https;AccountName=storagemainfotosplanten;AccountKey=YHIqjHCcXi8IO3DabS+N1lRzrBoltBaDDofu9vJmMo2tMQghoHMQ8fKT/GXVD0Q569EW8pfuJVqv7CjVkPreVA==;EndpointSuffix=core.windows.net');

    // Upload the image to the Blob storage on Azure => Bodybytes sends the data of the image
    await azureStorage.putBlob('/botanic/' + image.name,
        bodyBytes: await image.readAsBytes());

    // Wait for a result page from the AI API

    Result newResult = await _getResult(File(image.path));

    // Create a plant object in the database
    int plantId = await _createPlant(image.name, newResult.id);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green[400],
        content: Text("Successfully created a result")));
    // Go to the Result detail page of the newly created object
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlantDetailPage(id: plantId)),
    );
  }

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

    var res = response.stream.bytesToString().then((responseStream) {
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
        resultId: resultId,
        fieldName: fieldNameController.text,
        name: nameController.text);

    return PlantApi.createPlant(plant);
  }

  Future<Uint8List> _getImage(XFile image) async {
    // Returns the bytes of the image and these will be used to show the image.
    return await image.readAsBytes();
  }
}
