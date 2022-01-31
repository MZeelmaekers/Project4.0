import 'dart:typed_data';

import 'package:azblob/azblob.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../models/plant.dart';
import '../apis/plant_api.dart';

class PlantDetailPage extends StatefulWidget {
  final int id;

  const PlantDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _PlantDetailPageState createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  Plant? plant;
  AzureStorage azureStorage = AzureStorage.parse(
      'DefaultEndpointsProtocol=https;AccountName=storagemainfotosplanten;AccountKey=YHIqjHCcXi8IO3DabS+N1lRzrBoltBaDDofu9vJmMo2tMQghoHMQ8fKT/GXVD0Q569EW8pfuJVqv7CjVkPreVA==;EndpointSuffix=core.windows.net');

  @override
  void initState() {
    super.initState();
    _getPlant(widget.id);
  }

  void _getPlant(int id) {
    PlantApi.fetchPlant(id).then((result) {
      setState(() {
        plant = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result detail"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: _plantDetails(),
        ),
      ),
    );
  }

  _plantDetails() {
    if (plant == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      const TextStyle? textStyle = TextStyle(
        fontSize: 20.0,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal,
      );
      return Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.all(10.0)),
          FutureBuilder<Uint8List>(
            future: _getImage(plant!.fotoPath),
            builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
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
          const Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Text(
            "Plant name: " + plant!.name,
            style: textStyle,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Text(
            "Result: " + plant!.result!.prediction,
            style: textStyle,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Text("Accuracy: " + plant!.result!.accuracy.toString(),
              style: textStyle),
          const Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Text(
            "Field description: " + plant!.fieldName!,
            style: textStyle,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Text(
            "Date: " + plant!.createdAt,
            style: textStyle,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Text(
            "Location: " + plant!.location,
            style: textStyle,
          ),
        ],
      );
    }
  }

  Future<Uint8List> _getImage(String imageName) async {
    // This function gets the image from the Azure blob storage with azblob package.
    ByteStream? stream;
    Uint8List bytes = Uint8List(1);
    await azureStorage.getBlob('/botanic/' + imageName).then((result) {
      stream = result.stream;
    });
    await stream!.toBytes().then((result) {
      bytes = result;
    });
    // Returns the bytes of the image and these will be used to show the image.
    return bytes;
  }
}
