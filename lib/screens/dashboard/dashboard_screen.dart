import 'package:flutter_tes/config3.dart';
import 'package:flutter_tes/inputs.dart';
import 'package:flutter_tes/responsive.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:flutter/material.dart';
import 'package:flutter_tes/screens/dashboard/components/my_fieldsss.dart';
import '../../constants.dart';
import 'components/header.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:convert';

class DashboardScreen extends StatelessWidget {
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



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            AppBar(
              title: Text('authAdmin.name'),
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // Place buttons at opposite ends
                        children: [

                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Configg()),
                              );                            },
                            child: Text("ADD YOUR INPUTS"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showDialog(context);

                              // Handle right button press
                            },
                            child: Text("ADD Your Creadentials "),
                          ),

                        ],

                      ),

                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                // if (!Responsive.isMobile(context))
                //   Expanded(
                //     flex: 2,
                //     child: StorageDetails(),
                //   ),
              ],

            )
          ],
        ),
      ),
    );
  }


  Widget _buildBeautifulForm() {
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
                              // Handle selected country
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "City ",
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "How Many square meters ",
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Handle form submission
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

}
