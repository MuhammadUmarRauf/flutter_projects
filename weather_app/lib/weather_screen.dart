import 'dart:ui';

import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
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
                        spreadRadius: 0.1)
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '300°F',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Icon(
                            Icons.cloud,
                            size: 68,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Rain',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Weather Forecast',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HourlyForecastItem(),
                  HourlyForecastItem(),
                  HourlyForecastItem(),
                  HourlyForecastItem(),
                  HourlyForecastItem(),
                  HourlyForecastItem(),
                ],
              ),
            ),
            //Additional Information
            const Placeholder(
              fallbackHeight: 150,
            ),
          ],
        ),
      ),
    );
  }
}

class HourlyForecastItem extends StatelessWidget {
  const HourlyForecastItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 66, 66, 66),
      elevation: 8,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              '03:00',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Icon(Icons.cloud, size: 42),
            const SizedBox(height: 8),
            Text(
              '3:20',
            ),
          ],
        ),
      ),
    );
  }
}
