import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:sunshine_flutter/json_helper.dart';
import 'package:sunshine_flutter/resource_string_helper.dart';

import 'package:flutter/material.dart';

import 'package:sunshine_flutter/details_screen.dart';
import 'package:sunshine_flutter/sunshine_weather_utils.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<WeatherEntry> weather_items = [];
  bool _hasData = false;
  ResourceStringHelper helper;

  Widget _createWeatherRow(WeatherEntry entry, int index) {
    var rowEntry;
    var imageId = SunshineWeatherUtils
        .getSmallArtResourceIdForWeatherCondition(entry.weatherId);
    var imageLocation = "assets/$imageId";
    if (index == 0) {
      rowEntry =
          buildWeatherConditions(context, entry, textColor: Colors.white);
    } else {
      // is a normal day
      var weatherDescription =
          SunshineWeatherUtils.getStringForWeatherCondition(entry.weatherId);

      rowEntry = Row(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage(imageLocation),
                width: 48.0,
              )),
          Container(
              width: 240.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(formatDate(index),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(resourceHelper.getString(weatherDescription))
                ],
              )),
          Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Text(
                "${entry.high.round()}\u00b0",
                style: TextStyle(fontSize: 28.0),
              )),
          Text(
            "${entry.low.round()}\u00b0",
            style: TextStyle(fontSize: 28.0, color: Colors.grey),
          )
        ],
      );
    }

    return InkWell(
      onTap: () {
        print("clicked item");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetailsScreen(entry: entry, index: index)));
      },
      child: rowEntry,
    );
  }

  @override
  void initState() {
    super.initState();
    var url = "http://andfun-weather.udacity.com/staticweather";

    http.read(url).then((response) {
      setState(() {
        weather_items = weatherHelper(response);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Delay drawing the UI until the ResourceStringHelper has finished loading
    // it uses Futures/async
    return FutureBuilder<String>(
        future: resourceHelper.getFuture(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Text("Loading...");
            default:
              return createScaffold();
          }
        });
  }

  Widget createScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Image(
            image: AssetImage('assets/ic_logo.png'),
            fit: BoxFit.fill,
            width: 100.0),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: weather_items.length,
          itemBuilder: (context, index) {
            return _createWeatherRow(weather_items[index], index);
          }),
    );
  }
}
