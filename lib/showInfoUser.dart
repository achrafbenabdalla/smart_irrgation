import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tes/ListOfDemandeSensorsPage.dart';
import 'package:flutter_tes/ValidatedSensorsPage.dart';

import 'WaitingValidationPage.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  CustomCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
        ),
        child: Center(
          child: value
              ? Icon(
            Icons.check,
            size: 20,
            color: Colors.green,
          )
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}


class ShowUserDetails extends StatefulWidget {

  final bool isAdmin;
  late final bool isAccepted;
  final String name; // Add this field
  final String lastName; // Add this field
  final String cin; // Add this field
  final String password; // Add this field
  late  bool includepH;
  late  bool includeConductivity;
  late  bool includeOxygen;
  late  bool includeTemperature;
  ShowUserDetails({
    required this.name,
    required this.lastName,
    required this.cin,
    required this.includepH,
    required this.includeConductivity,
    required this.includeOxygen,
    required this.includeTemperature,
    required this.isAdmin,
    required this.isAccepted, required this.password,  // Initialize this parameter

  });


  @override
  _ShowUserDetailsState createState() => _ShowUserDetailsState();
}

class _ShowUserDetailsState extends State<ShowUserDetails> {
  late bool isAccepted;
  void _storeData() async {
    print('name: ${widget.name}, type: ${widget.name.runtimeType}');
    print('lastName: ${widget.lastName}, type: ${widget.lastName.runtimeType}');
    print('cin: ${widget.cin}, type: ${widget.cin.runtimeType}');
    print('includepH: ${widget.includepH}, type: ${widget.includepH.runtimeType}');
    print('includeOxygen: ${widget.includeOxygen}, type: ${widget.includeOxygen.runtimeType}');
    print('includeConductivity: ${widget.includeConductivity}, type: ${widget.includeConductivity.runtimeType}');
    print('includeTemperature: ${widget.includeTemperature}, type: ${widget.includeTemperature.runtimeType}');

    // Store the selected data in the 'demandesensors' collection
    await FirebaseFirestore.instance.collection('demandesensors').add({
      'name': widget.name,
      'lastName': widget.lastName,
      'password': widget.password,
      'includepH': widget.includepH,
      'includeOxygen': widget.includeOxygen,
      'includeConductivity': widget.includeConductivity,
      'includeTemperature': widget.includeTemperature,
      'etat': 'null', // or 'waiting', depending on your use case

    });

    // Show a snackbar to indicate that data was stored
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data stored successfully!')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WaitingValidationPage()),
    );

  }
  @override
  void initState() {
    isAccepted = false;
    print("Init state called"); // Print a message to the console

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Build method called"); // Print a message to the console

    bool dataSent =
        widget.name.isNotEmpty && widget.lastName.isNotEmpty && widget.cin.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.name.isEmpty && widget.lastName.isEmpty && widget.password.isEmpty
                    ? Text(
                  'Your data has not been submitted for validation yet.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : Column(
                    children: [
            Text(
              'Welcome, ${widget.name} ${widget.lastName}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
                      SizedBox(height: 8),
                      Text(
                        'My Password is: ${widget.password}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),  SizedBox(height: 8),
                      SizedBox(height: 8),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomCheckbox(
                  value: widget.includepH,
                  onChanged: (newValue) {
                    setState(() {
                      widget.includepH = newValue;
                      widget.isAccepted = true;


                    });
                  },
                ),
                SizedBox(width: 8), // Add some spacing
                Text(
                  'pH', // Label for the checkbox
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ), Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomCheckbox(
                  value: widget.includeOxygen,
                  onChanged: (newValue) {
                    setState(() {
                      widget.includeOxygen = newValue;
                    });
                  },
                ),
                SizedBox(width: 8), // Add some spacing
                Text(
                  'oxygen', // Label for the checkbox
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomCheckbox(
                  value: widget.includeTemperature,
                  onChanged: (newValue) {
                    setState(() {
                      widget.includeTemperature = newValue;
                    });
                  },
                ),
                SizedBox(width: 8), // Add some spacing
                Text(
                  'Temperture', // Label for the checkbox
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomCheckbox(
                  value: widget.includeConductivity,
                  onChanged: (newValue) {
                    setState(() {
                      widget.includeConductivity = newValue;
                    });
                  },
                ),
                SizedBox(width: 8), // Add some spacing
                Text(
                  'Conductivity', // Label for the checkbox
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _storeData,
                  child: Text('Store Data and View Validated Sensors'),
                ),



              ],
            ),

            SizedBox(height: 20),

            ])


          ])
    ),
    );
  }}
