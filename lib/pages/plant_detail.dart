import 'dart:typed_data';

import 'package:azblob/azblob.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:project40_mobile_app/apis/result_api.dart';
import 'package:project40_mobile_app/pages/plant_list.dart';
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
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[400], content: Text(error.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[400],
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext contex) {
                return AlertDialog(
                  title: Text("plant_detail-delete_question".i18n()),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text('cancel-text'.i18n()),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _deletePlant();
                        Navigator.pop(context, true);
                      },
                      child: Text('confirm-text'.i18n()),
                    ),
                  ],
                );
              });
        },
        child: Icon(Icons.delete),
      ),
      appBar: AppBar(
        title: Text("plant_detail-title".i18n()),
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
      return Center(
          child: Container(
              padding: EdgeInsets.all(20),
              child: const CircularProgressIndicator()));
    } else {
      const TextStyle? varTextStyle = TextStyle(
        fontSize: 20.0,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal,
      );
      const TextStyle? staticTextStyle = TextStyle(
        fontSize: 20.0,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.bold,
      );
      return Container(
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints.tight(Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(10.0)),
            FutureBuilder<Uint8List>(
              future: _getImage(plant!.fotoPath),
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Image.memory(
                    snapshot.data!,
                    height: 400.0,
                  );
                } else {
                  return Container(child: const CircularProgressIndicator());
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "plant_detail-plant_name_text".i18n(),
                  style: staticTextStyle,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    plant!.name,
                    style: varTextStyle,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "plant_detail-result_text".i18n(),
                  style: staticTextStyle,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    plant!.result!.prediction,
                    style: varTextStyle,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("plant_detail-accuracy_text".i18n(),
                    style: staticTextStyle),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(plant!.result!.accuracy.toStringAsFixed(2) + " %",
                      style: varTextStyle),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "plant_detail-field_text".i18n(),
                  style: staticTextStyle,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    plant!.fieldName,
                    style: varTextStyle,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "plant_detail-date_text".i18n(),
                  style: staticTextStyle,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    plant!.createdAt,
                    style: varTextStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Future<Uint8List> _getImage(String imageName) async {
    // This function gets the image from the Azure blob storage with azblob package.
    ByteStream? stream;
    Uint8List bytes = Uint8List(1);
    await azureStorage.getBlob('/botanic/' + imageName).then((result) {
      stream = result.stream;
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[400], content: Text(error.toString())));
    });
    await stream!.toBytes().then((result) {
      bytes = result;
    });
    // Returns the bytes of the image and these will be used to show the image.
    return bytes;
  }

  void _deletePlant() async {
    await PlantApi.deletePlant(plant!.id).then((result) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[400],
          content: Text("plant_detail-snackbar_delete_result_success".i18n())));
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[400], content: Text(error.toString())));
    });

    await ResultApi.deleteResult(plant!.resultId)
        .then((result) {})
        .onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[400], content: Text(error.toString())));
    });

    await azureStorage
        .putBlob("/botanic/" + plant!.fotoPath, bodyBytes: Uint8List(1))
        .then((result) {})
        .onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[400], content: Text(error.toString())));
    });

    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => PlantListPage()));
  }
}
