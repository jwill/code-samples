import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sunshine_flutter/home_screen.dart';
import 'package:sunshine_flutter/json_helper.dart';
import 'package:sunshine_flutter/resource_string_helper.dart';
import 'package:sunshine_flutter/sunshine_weather_utils.dart';
import "package:intl/intl.dart";



final resourceHelper = ResourceStringHelper();

void main() => runApp(new MyApp());

String formatTodaysDate() {
  var date = DateTime.now();
  var dateFormat = DateFormat("MMMM d");
  return "Today, " + dateFormat.format(date);
}

String formatDate(int index) {
  var daysToAdd = Duration(days:1* index);
  var date = DateTime.now().add(daysToAdd);
  if (index == 1) {
    return resourceHelper.getString("tomorrow");
  }else if (index < 7) {
    return DateFormat("EEEE").format(date);
  } else {
    return DateFormat("EEEE, MMMM d").format(date);
  }
}

// used on home and details screen
Widget buildWeatherConditions(BuildContext context, WeatherEntry entry,
{Color color = Colors.blue, Color textColor = Colors.black, index=0}) {
  var weatherDescriptionId = SunshineWeatherUtils.getStringForWeatherCondition(entry.weatherId);
  var weatherImage = SunshineWeatherUtils.getLargeArtResourceIdForWeatherCondition(entry.weatherId);
  String weatherDesc = resourceHelper.getString(weatherDescriptionId);

  var date = (index == 0) ? formatTodaysDate() : formatDate(index);

  var column = Column(children: <Widget>[
    Padding(
      padding: EdgeInsets.only(top: 32.0),
      child: Center(child: Text(date,
      style: TextStyle(fontSize: 18.0, color: textColor),)),
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            Image(image: AssetImage('assets/$weatherImage'),
              height:128.0
            ),
            Padding(padding: EdgeInsets.only(top:18.0),
                child:
            Text(weatherDesc,
            style: TextStyle(fontSize: 18.0, color: textColor),)),
          ],
        ),
        Column(
          children: <Widget>[
            Text(
              "${entry.high.round()}\u00b0",
              style: TextStyle(fontSize: 72.0, color: textColor),
            ),
            Text("${entry.low.round()}\u00b0", style: TextStyle(fontSize: 36.0, color: textColor))
          ],
        ),
      ],
    )
  ]);

  return Container(
      width: MediaQuery.of(context).size.width,
      color: color,
      child: Padding(
        padding: EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
        child: column,
      ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

