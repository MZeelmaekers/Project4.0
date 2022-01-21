import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../models/result.dart';
import '../apis/plant_api.dart';
import '../apis/result_api.dart';

class PlantDetailPage extends StatefulWidget {
  final String id;
  const PlantDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _PlantDetailPageState createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  Plant? plant;

  @override
  void initState() {
    super.initState();
    _getPlant(widget.id);
  }

  void _getPlant(String id) {
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
      body: Container(
        alignment: Alignment.center,
        child: _plantDetails(),
      ),
    );
  }

  _plantDetails() {
    if (plant == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      TextStyle? textStyle = TextStyle(
        fontSize: 20.0,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal,
      );
      return Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(10.0)),
          Image.network(
              "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Suikermais_kiemplant_groot.jpg/174px-Suikermais_kiemplant_groot.jpg"),
          Text(
            "Result: Week 3",
            style: textStyle,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Text(
            "Location: " + plant!.location,
            style: textStyle,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Text(
            "Date: " + plant!.createdAt,
            style: textStyle,
          )
        ],
      );
    }
  }
}
