import 'dart:convert';

/* Location information */
const String OWM_CITY = "city";
const String OWM_COORD = "coord";

/* Location coordinate */
const String OWM_LATITUDE = "lat";
const String OWM_LONGITUDE = "lon";

/* Weather information. Each day's forecast info is an element of the "list" array */
const String OWM_LIST = "list";

const String OWM_PRESSURE = "pressure";
const String OWM_HUMIDITY = "humidity";
const String OWM_WINDSPEED = "speed";
const String OWM_WIND_DIRECTION = "deg";

/* All temperatures are children of the "temp" object */
const String OWM_TEMPERATURE = "temp";

/* Max temperature for the day */
const String OWM_MAX = "max";
const String OWM_MIN = "min";

const String OWM_WEATHER = "weather";
const String OWM_WEATHER_ID = "id";

const String OWM_MESSAGE_CODE = "cod";

 List<WeatherEntry> weatherHelper(String input) {
    var jsonData = json.decode(input);
    print(jsonData);

    // get weather list
    var weatherList = jsonData[OWM_LIST];
    List<WeatherEntry> list = [];
    for (dynamic item in weatherList) {
      var w = WeatherEntry.fromJson(item);
      print(w.toJSON());
      list.add(w);
    }
    return list;
  }


class WeatherEntry {
  //WeatherEntry(this.dateTimeMillis, this.humidity, this.pressure, this.windSpeed, this.windDirection, this.high, this.low, this.weatherId);

  num dateTimeMillis;
  num pressure;
  num humidity;
  num windSpeed;
  num windDirection;

  num high;
  num low;
  int weatherId;

  Map<String, dynamic> toJSON() => {
        'dateTimeMillis': dateTimeMillis,
        'pressure': pressure,
        'humidity': humidity,
        'windSpeed': windSpeed,
        'windDirection': windDirection,
        'weatherId': weatherId,
        'high': high,
        'low' : low
      };

  static WeatherEntry fromJson(dynamic data) {
    var w = WeatherEntry();
    // fix this later
    w.dateTimeMillis = data["dt"];

    w.pressure = data[OWM_PRESSURE];
    w.humidity = data[OWM_HUMIDITY];
    w.windSpeed = data[OWM_WINDSPEED];
    w.windDirection = data[OWM_WIND_DIRECTION];

    /*
     * Description is in a child array called "weather", which is 1 element long.
     * That element also contains a weather code.
     */
    var weatherObject = data[OWM_WEATHER];
    print(weatherObject);
    w.weatherId = weatherObject[0][OWM_WEATHER_ID];

    var temperatureObject = data[OWM_TEMPERATURE];
    w.high = temperatureObject[OWM_MAX];
    w.low = temperatureObject[OWM_MIN];

    return w;
  }
}
