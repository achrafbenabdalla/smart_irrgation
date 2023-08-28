import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ValidatedSensorsPage extends StatefulWidget {
  final bool isAdmin;
  final bool isAccepted;

  ValidatedSensorsPage({required this.isAdmin, required this.isAccepted});

  @override
  _ValidatedSensorsPageState createState() => _ValidatedSensorsPageState();
}

class _ValidatedSensorsPageState extends State<ValidatedSensorsPage> {
  @override
  Widget build(BuildContext context) {
    CollectionReference validatedSensorsCollection =
    FirebaseFirestore.instance.collection('validatedsensors');

    return Scaffold(
      appBar: AppBar(
        title: widget.isAdmin
            ? Text('Validated Sensors (Admin)')
            : Text('Validated Sensors'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: validatedSensorsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No validated sensor data available.'),
            );
          }

          // Create a list of widgets to display the validated data
          List<Widget> validatedSensorWidgets =
          snapshot.data!.docs.map((document) {
            Map<String, dynamic> data =
            document.data() as Map<String, dynamic>;

            return Card(
              child: ListTile(
                title: Text(data['name'] + ' ' + data['lastName']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CIN: ${data['cin']}'),
                    Text('pH: ${data['includepH']}'),
                    Text('Conductivity: ${data['includeConductivity']}'),
                    Text('Temperature: ${data['includeTemperature']}'),
                    Text('Oxygen: ${data['includeOxygen']}'),
                  ],
                ),
              ),
            );
          }).toList();

          return ListView(
            children: validatedSensorWidgets,
          );
        },
      ),
    );
  }
}
