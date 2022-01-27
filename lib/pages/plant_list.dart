import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project40_mobile_app/pages/plant_detail.dart';
import '../models/result.dart';
import '../apis/result_api.dart';
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
          ? CircularProgressIndicator()
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
            margin: EdgeInsets.all(10.0),
            child: ListTile(
                leading: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Suikermais_kiemplant_groot.jpg/174px-Suikermais_kiemplant_groot.jpg"),
                title: Text(
                  plantList[position].createdAt.toString(),
                  style: TextStyle(
                    fontSize: 16.0,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  plantList[position].location.toString(),
                  style: TextStyle(
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
}
