// ignore_for_file: prefer_const_constructors


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tes/confirledAlldataUser.dart';

import 'package:flutter_tes/forget_pw.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tes/showInfoUser.dart';
import 'package:flutter_tes/splashscreen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'constants.dart';

import 'package:http/http.dart' as http;


class DahUser extends StatefulWidget {
  final String name;
  final String lastName;
  final String cin;
  final String password;
  final bool includepH;
  final bool includeOxygen;
  final bool includeConductivity;
  final bool includeTemperature;

  const DahUser({
    Key? key,
    required this.name,
    required this.lastName,
    required this.cin,
    required this.includepH,
    required this.includeOxygen,
    required this.includeConductivity,
    required this.includeTemperature,
    required this.password,
  }) : super(key: key);

  @override
  _DahUserState createState() => _DahUserState();
}
class _DahUserState extends State<DahUser> {
  Map<String, dynamic> enteredValues = {
    'country': '',
    'city': '',
    'squareMeters': '',
  };

  Future<List<Map<String, dynamic>>> fetchAcceptedUsersData(String name, String lastName, String cin) async {
    // Fetch data from the "demandesensors" collection in Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('demandesensors')
        .where('isAccepted', isEqualTo: true)
        .where('name', isEqualTo: name)
        .where('lastName', isEqualTo: lastName)
        .where('cin', isEqualTo: cin)
        .get();

    // Convert each document to a map
    List<Map<String, dynamic>> data = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    return data;
  }

  dynamic data;
  Map<String, dynamic> settingsData = {};
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;

    super.initState();
  }
  Future<List<Map<String, dynamic>>> fetchCountries() async {
    final response = await http.get(
        Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch countries');
    }
  }

  Widget _buildBeautifulForm() {
    TextEditingController _countryController = TextEditingController();

    return Form(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 16),
              Text(
                "thanks for adding your coordinates!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchCountries(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data available');
                    } else {
                      List<Map<String, dynamic>>? countries = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TypeAheadFormField<Map<String, dynamic>>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: _countryController,

                              decoration: InputDecoration(
                                labelText: 'Country',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return countries!
                                  .where((country) =>
                                  country['name']['common']
                                      .toLowerCase()
                                      .contains(pattern.toLowerCase()))
                                  .toList();
                            },
                            itemBuilder: (context, country) {
                              return ListTile(
                                title: Text(country['name']['common']),
                              );
                            },
                            onSuggestionSelected: (selectedCountry) {
                              setState(() {
                                _countryController.text = selectedCountry['name']['common'];
                                enteredValues['country'] = selectedCountry['name']['common'];
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "City (${_countryController.text})",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                enteredValues['city'] = value;
                              });
                            },
                            obscureText: false,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "How Many square meters",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                enteredValues['squareMeters'] = value;
                              });
                            },
                            obscureText: false,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Container(
                                      width: 400,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Card(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                leading: Icon(Icons.person),
                                                title: Text('Name: ${widget.name} ${widget.lastName}'),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.thermostat),
                                                title: Text('Include Temperature: ${widget.includeTemperature}'),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.settings),
                                                title: Text('Include Conductivity: ${widget.includeConductivity}'),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.waves),
                                                title: Text('Include Oxygen: ${widget.includeOxygen}'),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.phonelink),
                                                title: Text('Include pH: ${widget.includepH}'),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.location_on),
                                                title: Text('Country: ${enteredValues['country']}'),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.location_city),
                                                title: Text('City: ${enteredValues['city']}'),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.square_foot),
                                                title: Text('Square Meters: ${enteredValues['squareMeters']}'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Handle confirmation action

                                                      Navigator.of(context).pop(); // Close the dialog
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => ConfirmedDataPage(
                                                      name: widget.name,
                                                      lastName: widget.lastName,
                                                      cin: widget.cin,
                                                      includepH: widget.includepH,
                                                      includeOxygen: widget.includeOxygen,
                                                      includeConductivity: widget.includeConductivity,
                                                      includeTemperature: widget.includeTemperature,
                                                      country: enteredValues['country'],
                                                      city: enteredValues['city'],
                                                      squareMeters: enteredValues['squareMeters'],
                                                    ),
                                                  ));
                                                },
                                                child: Text("Confirm"),
                                              ), ElevatedButton(
                                                onPressed: () {
                                                  // Handle confirmation action
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Credentials not confirmed !')),
                                                  );
                                                },
                                                child: Text("return"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text("Submit"),
                          ),

                          // ... your other form fields ...
                        ],

                      );
                    }
                  })
            ]));
  }
  void _navigateToShowUserDetails() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShowUserDetails(
        // Pass all the collected data to ShowUserDetails
        name: widget.name,
        lastName: widget.lastName,
        cin: widget.cin,
        includepH: widget.includepH,
        includeOxygen: widget.includeOxygen,
        includeConductivity: widget.includeConductivity,
        includeTemperature: widget.includeTemperature,
     isAdmin: false, isAccepted: true, password:widget.password,
      ),
    ));
  }

  Future<void> _showDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            child:Container(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildBeautifulForm(),
              ),
            ));
      },
    );
  }
  Future<List<Map<String, dynamic>>> fetchDemandSensorsData() async {
    // Fetch data from the "demandsensors" collection in Firestore
    // Replace this with your actual data fetching logic
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('demandesensors').get();

    // Convert each document to a map
    List<Map<String, dynamic>> data = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    return data;
  }

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        backgroundColor: Color(0xff259e73), // Adjust the color of the app bar
      ),
      body: Center(
        child: Column(
          children: [
            // Your button placed at the top-right corner
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child:   ElevatedButton(
                  onPressed: () {
                    _showDialog(context);

                    // Handle right button press
                  },
                  child: Text("ADD Your Creadentials "),
                ),

              ),
            ),
             Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Name: ${widget.name} ${widget.lastName}'),
                  ),
                  ListTile(
                    title: Text('Include Temperature: ${widget.includeTemperature}'),
                  ),
                  ListTile(
                    title: Text('Include Conductivity: ${widget.includeConductivity}'),
                  ),
                  ListTile(
                    title: Text('Include Oxygen: ${widget.includeOxygen}'),
                  ),
                  ListTile(
                    title: Text('Include pH: ${widget.includepH}'),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchDemandSensorsData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return Text('No data available');
    } else {
    List<Map<String, dynamic>> sensorData = snapshot.data!;
    return Column(
    );

                }
              },
            ),
            // Your existing body content
          ],

        ),

      ),
    );
  }
}
