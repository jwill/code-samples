/*
 * Copyright (C) 2016 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


/**
 * Contains useful utilities for a weather app, such as conversion between Celsius and Fahrenheit,
 * from kph to mph, and from degrees to NSEW.  It also contains the mapping of weather condition
 * codes in OpenWeatherMap to strings.  These strings are contained
 */
import "package:sunshine_flutter/main.dart";
class SunshineWeatherUtils {

    //private static final String LOG_TAG = SunshineWeatherUtils.class.getSimpleName();

    /**
     * This method will convert a temperature from Celsius to Fahrenheit.
     *
     * @param temperatureInCelsius Temperature in degrees Celsius(°C)
     *
     * @return Temperature in degrees Fahrenheit (°F)
     */
    static double celsiusToFahrenheit(double temperatureInCelsius) {
        double temperatureInFahrenheit = (temperatureInCelsius * 1.8) + 32;
        return temperatureInFahrenheit;
    }


    /**
     * This method uses the wind direction in degrees to determine compass direction as a
     * String. (eg NW) The method will return the wind String in the following form: "2 km/h SW"
     *
     * @param context   Android Context to access preferences and resources
     * @param windSpeed Wind speed in kilometers / hour
     * @param degrees   Degrees as measured on a compass, NOT temperature degrees!
     *                  See https://www.mathsisfun.com/geometry/degrees.html
     *
     * @return Wind String in the following form: "2 km/h SW"
     */
    static String getFormattedWind( num windSpeed, num degrees) {
        String windFormat = resourceHelper.getString("format_wind_kmh");

        /*
         * You know what's fun? Writing really long if/else statements with tons of possible
         * conditions. Seriously, try it!
         */
        String direction = "Unknown";
        if (degrees >= 337.5 || degrees < 22.5) {
            direction = "N";
        } else if (degrees >= 22.5 && degrees < 67.5) {
            direction = "NE";
        } else if (degrees >= 67.5 && degrees < 112.5) {
            direction = "E";
        } else if (degrees >= 112.5 && degrees < 157.5) {
            direction = "SE";
        } else if (degrees >= 157.5 && degrees < 202.5) {
            direction = "S";
        } else if (degrees >= 202.5 && degrees < 247.5) {
            direction = "SW";
        } else if (degrees >= 247.5 && degrees < 292.5) {
            direction = "W";
        } else if (degrees >= 292.5 && degrees < 337.5) {
            direction = "NW";
        }

        return "$windSpeed $windFormat $direction";

        //return String.format(context.getString(windFormat), windSpeed, direction);
    }

    /**
     * Helper method to provide the string according to the weather
     * condition id returned by the OpenWeatherMap call.
     *
     * @param context   Android context
     * @param weatherId from OpenWeatherMap API response
     *                  See http://openweathermap.org/weather-conditions for a list of all IDs
     *
     * @return String for the weather condition, null if no relation is found.
     */
    static String getStringForWeatherCondition(int weatherId) {
        String stringId;
        if (weatherId >= 200 && weatherId <= 232) {
            stringId = "condition_2xx";
        } else if (weatherId >= 300 && weatherId <= 232) {
            stringId = "condition_3xx";
        } else {
            stringId = "condition_$weatherId";
        }

        // TODO Verify that the condition code exists
        // If not, rewrite to unknown

        return stringId;
    }

    /**
     * Helper method to provide the icon resource id according to the weather condition id returned
     * by the OpenWeatherMap call. This method is very similar to
     *
     *   {@link #getLargeArtResourceIdForWeatherCondition(int)}.
     *
     * The difference between these two methods is that this method provides smaller assets, used
     * in the list item layout for a "future day", as well as
     *
     * @param weatherId from OpenWeatherMap API response
     *                  See http://openweathermap.org/weather-conditions for a list of all IDs
     *
     * @return resource id for the corresponding icon. -1 if no relation is found.
     */
    static String getSmallArtResourceIdForWeatherCondition(int weatherId) {

        /*
         * Based on weather code data for Open Weather Map.
         */
        if (weatherId >= 200 && weatherId <= 232) {
            return "ic_storm.png";
        } else if (weatherId >= 300 && weatherId <= 321) {
            return "ic_light_rain.png";
        } else if (weatherId >= 500 && weatherId <= 504) {
            return "ic_rain.png";
        } else if (weatherId == 511) {
            return "ic_snow.png";
        } else if (weatherId >= 520 && weatherId <= 531) {
            return "ic_rain.png";
        } else if (weatherId >= 600 && weatherId <= 622) {
            return "ic_snow.png";
        } else if (weatherId >= 701 && weatherId <= 761) {
            return "ic_fog.png";
        } else if (weatherId == 761 || weatherId == 771 || weatherId == 781) {
            return "ic_storm.png";
        } else if (weatherId == 800) {
            return "ic_clear.png";
        } else if (weatherId == 801) {
            return "ic_light_clouds.png";
        } else if (weatherId >= 802 && weatherId <= 804) {
            return "ic_cloudy.png";
        } else if (weatherId >= 900 && weatherId <= 906) {
            return "ic_storm.png";
        } else if (weatherId >= 958 && weatherId <= 962) {
            return "ic_storm.png";
        } else if (weatherId >= 951 && weatherId <= 957) {
            return "ic_clear.png";
        }

        print("Unknown Weather: $weatherId");
        return "ic_storm.png";
    }

    /**
     * Helper method to provide the art resource ID according to the weather condition ID returned
     * by the OpenWeatherMap call. This method is very similar to
     *
     *   {@link #getSmallArtResourceIdForWeatherCondition(int)}.
     *
     * The difference between these two methods is that this method provides larger assets, used
     * in the "today view" of the list, as well as in the DetailActivity.
     *
     * @param weatherId from OpenWeatherMap API response
     *                  See http://openweathermap.org/weather-conditions for a list of all IDs
     *
     * @return resource ID for the corresponding icon. -1 if no relation is found.
     */
    static String getLargeArtResourceIdForWeatherCondition(int weatherId) {

        /*
         * Based on weather code data for Open Weather Map.
         */
        if (weatherId >= 200 && weatherId <= 232) {
            return "art_storm.png";
        } else if (weatherId >= 300 && weatherId <= 321) {
            return "art_light_rain.png";
        } else if (weatherId >= 500 && weatherId <= 504) {
            return "art_rain.png";
        } else if (weatherId == 511) {
            return "art_snow.png";
        } else if (weatherId >= 520 && weatherId <= 531) {
            return "art_rain.png";
        } else if (weatherId >= 600 && weatherId <= 622) {
            return "art_snow.png";
        } else if (weatherId >= 701 && weatherId <= 761) {
            return "art_fog.png";
        } else if (weatherId == 761 || weatherId == 771 || weatherId == 781) {
            return "art_storm.png";
        } else if (weatherId == 800) {
            return "art_clear.png";
        } else if (weatherId == 801) {
            return "art_light_clouds.png";
        } else if (weatherId >= 802 && weatherId <= 804) {
            return "art_clouds.png";
        } else if (weatherId >= 900 && weatherId <= 906) {
            return "art_storm.png";
        } else if (weatherId >= 958 && weatherId <= 962) {
            return "art_storm.png";
        } else if (weatherId >= 951 && weatherId <= 957) {
            return "art_clear.png";
        }

        print("Unknown Weather: $weatherId");
        return "art_storm.png";
    }
}