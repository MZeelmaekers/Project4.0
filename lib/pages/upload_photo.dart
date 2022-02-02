import 'package:azblob/azblob.dart';
import 'package:flutter/material.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:project40_mobile_app/pages/photo_detail.dart';
import 'package:image_picker/image_picker.dart';

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
        title: Text("upload_photo-title".i18n()),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(10.0)),
              Text(
                "upload_photo-upload_text".i18n(),
                style: const TextStyle(
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green[400],
        content: Text("upload_photo-snackbar_upload_success".i18n())));
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PhotoDetailPage(image: image)));
  }
}
