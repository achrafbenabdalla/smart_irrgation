import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample1 extends StatefulWidget {
  BarChartSample1({Key? key}) : super(key: key);

  final Color barBackgroundColor = Colors.white70;
  final Color barColor = Colors.white;
  final Color touchedBarColor = Colors.green;
  @override
  BarChartSample1State createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Duration animDuration = const Duration(milliseconds: 250);
  List<Color> gradientColors = [Colors.cyan, Colors.blue];
  dynamic sensorData;
  dynamic data;
  String tempData = "";
  Map<String, dynamic> settingsData = {};
  List<int> demoMyFiles = [];
  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    var userID = user!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .snapshots()
        .listen((docSnapshot) {
      fetchDataAndDisplay();
    });
  }

  List<FlSpot> flSpotsList = [];

  Future<List> getLast10DataHIS(String userId) async {
    try {
      // Reference to the Firestore collection
      User? user = FirebaseAuth.instance.currentUser;
      var userID = user!.uid;

      // Get the user's document by user ID
      DocumentSnapshot<Map<String, dynamic>> userDocument =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userID)
              .get();

      // Check if the document exists
      if (userDocument.exists) {
        // Get the 'data_his' field as a Map

        Map<String, dynamic> dataHIS = userDocument.data()!['data_his'];

        // Convert the 'data_his' values to a list of maps
        List dataHISList = dataHIS.values.toList();

        // Sort the list by timestamp in descending order (assuming timestamp is a number)
        dataHISList.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

        // Take the first 10 elements (last 10 elements after sorting)
        List last10DataHIS = dataHISList.take(10).toList();

        return last10DataHIS;
      } else {
        // Handle the case where the user document doesn't exist
        return [];
      }
    } catch (e) {
      // Handle any errors that may occur during the retrieval
      print('Error getting data_his: $e');
      return [];
    }
  }

  List<FlSpot> convertDataToFlSpots(List last10Data) {
    List<FlSpot> flSpots = [];

    for (Map<String, dynamic> dataPoint in last10Data) {
      double timestamp = dataPoint['timestamp']; // Convert timestamp to double
      double temp = dataPoint['temp']; // Convert temp to double

      // Create an FlSpot object and add it to the list
      flSpots.add(FlSpot(timestamp, temp));
    }

    return flSpots;
  }

  Future<void> fetchDataAndDisplay() async {
    User? user = FirebaseAuth.instance.currentUser;
    var userID = user!.uid;
    List last10Data = await getLast10DataHIS(userID);
    // Display the last 10 data points in your UI or perform further processing
    // List<FlSpot> flSpotsList = convertDataToFlSpots(last10Data);
    setState(() {
      flSpotsList = convertDataToFlSpots(last10Data);
    });
    print(flSpotsList);
  }

  bool showAvg = false;
  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              showAvg ? avgData() : mainData(),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 10:
        text = '10C°';
        break;
      case 30:
        text = '30C°';
        break;
      case 50:
        text = '50C°';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: null,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0x11FFFFFF),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0x11FFFFFF),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 50,
      lineBarsData: [
        LineChartBarData(
          spots: flSpotsList,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: flSpotsList,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(










              
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
