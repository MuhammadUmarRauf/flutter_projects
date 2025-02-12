import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
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
    print('build fn called');
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
              setState(() {}); // Refreshes the data
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
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
          final tempKelvin = data['list'][0]['main']['temp'];
          final tempCelsius = (tempKelvin - 273.15).toStringAsFixed(1);
          final weatherCondition = data['list'][0]['weather'][0]['main'];
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
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          color: const Color.fromARGB(255, 82, 79, 79),
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
                  'Weather Forecast',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HourlyForecastItem(
                        time: '00:00',
                        icon: Icons.cloud,
                        temperature: '301.22',
                      ),
                      HourlyForecastItem(
                        time: '03:00',
                        icon: Icons.sunny,
                        temperature: '300.52',
                      ),
                      HourlyForecastItem(
                        time: '06:00',
                        icon: Icons.cloud,
                        temperature: '302.22',
                      ),
                      HourlyForecastItem(
                        time: '09:00',
                        icon: Icons.sunny,
                        temperature: '312.24',
                      ),
                      HourlyForecastItem(
                        time: '12:00',
                        icon: Icons.cloud,
                        temperature: '304.22',
                      ),
                    ],
                  ),
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
                      value: '${data['list'][0]['main']['humidity']}%',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '${data['list'][0]['wind']['speed']} m/s',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '${data['list'][0]['main']['pressure']} hPa',
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
