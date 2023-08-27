import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class chart extends StatefulWidget {
  const chart({Key? key});

  @override
  _chartState createState() => _chartState();
}

class _chartState extends State<chart> {
  List<double> temperatureData =
      []; // Keep the temperature data at the class level

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff259e73), // Adjust the color of the app bar
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              temperatureData.clear(); // Clear the previous data
              snapshot.data!.docs.forEach((documentSnapshot) {
                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;
                if (data.containsKey('data')) {
                  Map<String, dynamic> userData =
                      data['data'] as Map<String, dynamic>;
                  if (userData.containsKey('temp')) {
                    double temperature = userData['temp'] as double;
                    temperatureData.add(temperature);
                  }
                }
              });

              return LineChart(
                LineChartData(
                  // Customize the chart data and appearance here
                  minX: 0,
                  maxX: temperatureData.length.toDouble() - 1,
                  minY: temperatureData
                      .reduce((min, value) => min < value ? min : value),
                  maxY: temperatureData
                      .reduce((max, value) => max > value ? max : value),
                  lineBarsData: [
                    LineChartBarData(
                      spots: temperatureData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      // Customize bar appearance as needed
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
