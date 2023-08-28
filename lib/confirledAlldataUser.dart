import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConfirmedDataPage extends StatelessWidget {
  final String name;
  final String lastName;
  final String cin;
  final bool includepH;
  final bool includeOxygen;
  final bool includeConductivity;
  final bool includeTemperature;
  final String country;
  final String city;
  final String squareMeters;

  ConfirmedDataPage({
    required this.name,
    required this.lastName,
    required this.cin,
    required this.includepH,
    required this.includeOxygen,
    required this.includeConductivity,
    required this.includeTemperature,
    required this.country,
    required this.city,
    required this.squareMeters,
  });
  Future<void> addConfirmedClientData() async {
    // Create a map with the confirmed client data
    Map<String, dynamic> confirmedClientData = {
      'name': name,
      'lastName': lastName,
      'cin': cin,
      'includepH': includepH,
      'includeOxygen': includeOxygen,
      'includeConductivity': includeConductivity,
      'includeTemperature': includeTemperature,
      'country': country,
      'city': city,
      'squareMeters': squareMeters,
    };

    // Add the data to the 'confirmedclient' collection
    await FirebaseFirestore.instance.collection('confirmedclient').add(confirmedClientData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmed Data'),
        backgroundColor: Color(0xff259e73),
      ),
      body: Center(
        // Display your confirmed data with a beautiful design
        // You can use Columns, Rows, Icons, Texts, etc. to design the layout
        // Example:
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Name: $name $lastName'),
            ),

            ListTile(
              leading: Icon(Icons.thermostat),
              title: Text('Include Temperature: $includeTemperature'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Include Conductivity: $includeConductivity'),
            ),
            ListTile(
              leading: Icon(Icons.waves),
              title: Text('Include Oxygen: $includeOxygen'),
            ),
            ListTile(
              leading: Icon(Icons.phonelink),
              title: Text('Include PH: $includepH'),
            ),
            // Add more ListTile widgets for other data
            // You can customize the design as you want
            // You can customize the design as you want
          ],
        ),
      ),
    );
  }
}
