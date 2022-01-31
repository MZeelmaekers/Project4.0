import 'dart:typed_data';

import 'package:azblob/azblob.dart';
import 'package:flutter/material.dart';
import 'package:project40_mobile_app/apis/plant_api.dart';
import 'package:project40_mobile_app/apis/result_api.dart';
import 'package:project40_mobile_app/models/plant.dart';
import 'package:project40_mobile_app/models/result.dart';
import 'package:project40_mobile_app/pages/photo_detail.dart';
import 'package:project40_mobile_app/pages/plant_detail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project40_mobile_app/global_vars.dart' as global;

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

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _navigateToPhotoDetailPage(pickedImage);
    }
  }

  void _navigateToPhotoDetailPage(XFile image) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PhotoDetailPage(image: image)));
  }
}
