import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Lahore';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherAPIKey'),
      );

      if (res.statusCode != 200) {
        throw 'Failed to fetch weather data';
      }

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred: ${data['message']}';
      }

      return data;
    } catch (e) {
      print('Error: $e');
      return {}; // Return empty map instead of null
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny; // 🌞 Sunny
      case 'clouds':
        return Icons.cloud; // ☁️ Cloudy
      case 'rain':
        return Icons.umbrella; // 🌧️ Rainy
      case 'thunderstorm':
        return Icons.thunderstorm; // 🌩️ Stormy
      case 'snow':
        return Icons.ac_unit; // ❄️ Snowy
      case 'mist':
      case 'fog':
        return Icons.foggy; // 🌫️ Foggy
      default:
        return Icons.wb_cloudy; // Default cloudy icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              }); // Refreshes the data
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final tempKelvin = currentWeatherData['main']['temp'];
          final tempCelsius = (tempKelvin - 273.15).toStringAsFixed(1);
          final weatherCondition = currentWeatherData['weather'][0]['main'];
          final weatherIcon = getWeatherIcon(weatherCondition);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Main Card
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(66, 82, 79, 79),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 2,
                          color: Color.fromARGB(255, 82, 79, 79),
                          spreadRadius: 0.1,
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$tempCelsius°C',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                weatherIcon,
                                size: 68,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                weatherCondition,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i <= 39; i++)
                //         HourlyForecastItem(
                //           time: DateTime.fromMillisecondsSinceEpoch(
                //                   data['list'][i]['dt'] * 1000)
                //               .toLocal()
                //               .toString()
                //               .substring(11, 16), // Extract HH:mm
                //           icon: getWeatherIcon(
                //               data['list'][i]['weather'][0]['main']),
                //           temperature:
                //               '${(data['list'][i]['main']['temp'] - 273.15).toStringAsFixed(1)}°C',
                //         ),
                //     ],
                //   ),
                // ),

                SizedBox(
                  height: 125,
                  child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final hourlyForecastItem = data['list'][index + 1];
                        final hourlyWeather =
                            data['list'][index + 1]['weather'][0]['main'];
                        final hourlytemp =
                            hourlyForecastItem['main']['temp'].toString();
                        final time =
                            DateTime.parse(hourlyForecastItem['dt_txt']);
                        return HourlyForecastItem(
                            time: DateFormat.j().format(time),
                            temperature: hourlytemp,
                            icon: hourlyWeather == 'Clouds' ||
                                    hourlyWeather == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny);
                      }),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '${currentWeatherData['main']['humidity']}%',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '${currentWeatherData['wind']['speed']} m/s',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '${currentWeatherData['main']['pressure']} hPa',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
