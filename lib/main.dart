import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<FlSpot> data = [];
  double lastDate = 0; // Initialize with 0

  @override
  void initState() {
    super.initState();
    updateData();
    // Set up a periodic timer to update the chart every second
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      updateData();
    });
  }

  void updateData() {
    final min = 10;
    final max = 90;
    final randomValue = min + Random().nextInt(max - min);

    setState(() {
      lastDate += 1.0; // Add 1 second to the lastDate
      data.add(FlSpot(lastDate, randomValue.toDouble()));

      // Keep only the last 10 data points to mimic the behavior of your example
      if (data.length > 10) {
        data.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Random Updating Chart'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTextStyles: (context, value) =>
                      const TextStyle(color: Colors.black, fontSize: 12),
                  interval: 20, // Adjust the interval as needed
                ),
                bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTextStyles: (context, value) =>
                      const TextStyle(color: Colors.black, fontSize: 12),
                  interval: 1, // Each second on x-axis
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: lastDate - 10, // Adjust the range as needed
              maxX: lastDate,
              minY: 0,
              maxY: 100,
              lineBarsData: [
                LineChartBarData(
                  spots: data,
                  isCurved: true,
                  colors: [Colors.blue],
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
