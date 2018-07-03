import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sunshine_flutter/json_helper.dart';
import 'package:sunshine_flutter/resource_string_helper.dart';
import 'dart:async';
import 'package:xml/xml.dart' as xml;
import 'main.dart';
import 'package:sunshine_flutter/sunshine_weather_utils.dart';

class DetailsScreen extends StatelessWidget {
  final WeatherEntry entry;
  final int index;  // day index
  DetailsScreen({Key key, @required this.entry, @required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Details")),
        body: Column(
          children: <Widget>[
            buildWeatherConditions(context, entry, color:Colors.white, index:index),
            buildSensorDetails(context)
          ],
        ));
  }

  Widget createSensorListView(BuildContext context, String label, String data) {
    var row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label,
              style: TextStyle(color: Color(0xFF90A4AE), fontSize: 20.0)),
          Text(data, style: TextStyle(color: Colors.white, fontSize: 24.0))
        ]);

    return Padding(
      padding: EdgeInsets.all(32.0),
      child: row,
    );
  }

  Widget buildSensorDetails(BuildContext context) {
    var wind = SunshineWeatherUtils.getFormattedWind(entry.windSpeed, entry.windDirection);
    return Expanded(
        child: Container(
          color: Color(0xFF455A64),
          child: Column(
            children: <Widget>[
              createSensorListView(context, "Humidity", "${entry.humidity}%"),
              createSensorListView(context, "Pressure", "${entry.pressure} hPa"),
              createSensorListView(context, "Wind", wind),
            ],
          ),
        ));
    //return Text("Sensor Details");
  }
}
