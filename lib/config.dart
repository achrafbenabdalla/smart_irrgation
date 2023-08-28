import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ConfigurationList.dart';

class Configg extends StatefulWidget {
  @override
  _ConfiggState createState() => _ConfiggState();
}

class _ConfiggState extends State<Configg> {
  bool includepH = false;
  bool includeConductivity = false;
  bool includeOxygen = false;
  bool includeTemperature = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController cinController = TextEditingController();

  void _saveConfiguration() {
    String name = nameController.text;
    String lastName = lastNameController.text;
    String cin = cinController.text;

    FirebaseFirestore.instance.collection('demandeInputs').add({
      'pH': includepH,
      'conductivity': includeConductivity,
      'oxygen': includeOxygen,
      'temperature': includeTemperature,
      'name': name,
      'lastname': lastName,
      'cin': cin,
    }).then((_) {
      print("Data added to Firestore"); // Print when data is added
    }).catchError((error) {
      print("Error adding data to Firestore: $error"); // Print if an error occurs
    });

    // Clear text fields and checkboxes after saving
    nameController.clear();
    lastNameController.clear();
    cinController.clear();
    setState(() {
      includepH = false;
      includeConductivity = false;
      includeOxygen = false;
      includeTemperature = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuration'),
      ),
      body: Column(
        children: [
          CheckboxListTile(
            title: Text('pH'),
            value: includepH,
            onChanged: (newValue) {
              setState(() {
                includepH = newValue!;
              });
            },
          ),
          // Other CheckboxListTile widgets for other options...

          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Enter your name'),
          ),
          TextField(
            controller: lastNameController,
            decoration: InputDecoration(labelText: 'Enter your last name'),
          ),
          TextField(
            controller: cinController,
            decoration: InputDecoration(labelText: 'Enter your Cin'),
          ),

          ElevatedButton(
            onPressed: () {
              _saveConfiguration;

              Navigator.push(

                context,
                MaterialPageRoute(
                  builder: (context) => ConfigurationList(name: '', lastName: '', cin: '', isAdmin: false,), // Pass the user's name
                ),
              );
            },

            child: Text('Save Configuration'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: Configg()));
}
