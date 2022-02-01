import 'dart:typed_data';

import 'package:azblob/azblob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project40_mobile_app/pages/plant_detail.dart';
import '../models/plant.dart';
import '../apis/plant_api.dart';
import 'package:project40_mobile_app/global_vars.dart' as global;

class PlantListPage extends StatefulWidget {
  const PlantListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlantListPageState();
}

class _PlantListPageState extends State<PlantListPage> {
  List<Plant> plantList = [];
  int count = 0;
  bool _isLoading = false;
  int userId = global.userId;
  String token = global.userToken;
  AzureStorage azureStorage = AzureStorage.parse(
      'DefaultEndpointsProtocol=https;AccountName=storagemainfotosplanten;AccountKey=YHIqjHCcXi8IO3DabS+N1lRzrBoltBaDDofu9vJmMo2tMQghoHMQ8fKT/GXVD0Q569EW8pfuJVqv7CjVkPreVA==;EndpointSuffix=core.windows.net');

  @override
  void initState() {
    super.initState();
    _getPlants();
  }

  void _getPlants() {
    setState(() {
      _isLoading = true;
      plantList = [];
      count = 0;
    });
    PlantApi.fetchPlantsFromUserId(userId).then((result) {
      setState(() {
        plantList = result;
        count = result.length;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[400],
          content: Text("Successfully loaded results")));
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[400], content: Text(error.toString())));
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getPlants();
        },
        tooltip: "Refresh",
        child: const Icon(Icons.refresh),
      ),
      body: _isLoading
          ? const CircularProgressIndicator()
          : Container(
              alignment: Alignment.center,
              child: _plantListItems(),
            ),
    );
  }

  ListView _plantListItems() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            margin: const EdgeInsets.all(10.0),
            child: ListTile(
                leading: FutureBuilder<Uint8List>(
                  future: _getImage(plantList[position].fotoPath),
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
                title: Text(
                  plantList[position].name,
                  style: const TextStyle(
                    fontSize: 16.0,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  plantList[position].createdAt.toString(),
                  style: const TextStyle(
                    fontSize: 16.0,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onTap: () {
                  _navigateToPlantDetail(plantList[position].id);
                }),
          );
        });
  }

  void _navigateToPlantDetail(int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlantDetailPage(id: id)),
    );

    _getPlants();
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
}
