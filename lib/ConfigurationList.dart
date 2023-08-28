import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dash.dart';

enum FilterState {
  All, // Toutes les demandes
  Accepted, // Demandes acceptées
  Rejected, // Demandes rejetées
  NotProcessed, // Demandes non traitées
}
class ConfigurationList extends StatefulWidget {
  final String name;
  final String lastName;
  final String cin;
  final bool isAdmin; // Add isAdmin property

  ConfigurationList({
    required this.name,
    required this.lastName,
    required this.cin,
    required this.isAdmin,
  });

  @override
  _ConfigurationListState createState() => _ConfigurationListState();

}

class _ConfigurationListState extends State<ConfigurationList> {
  List<String> acceptedConfigurations = [];
  List<String> rejectedConfigurations = [];
  bool isAccepted = true;
  Map<String, bool> configurationStates = {}; // Map to store configuration states
  FilterState currentFilter = FilterState.All;
  CollectionReference validatedInputsCollection = FirebaseFirestore.instance.collection('validatedInputs');

  @override
  Widget build(BuildContext context) {
    print("Received Name: ${widget.name}");
    print("Received Last Name: ${widget.lastName}");
    print("Received CIN: ${widget.cin}");
    bool isAdmin = widget.isAdmin;

    if (isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Unauthorized Access'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You do not have permission to access this page.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the user dashboard
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashUser(),
                    ),
                  );
                },
                child: Text('Go to User Dashboard'),
              ),
            ],
          ),
        ),
      );

    } else
    {
      return Scaffold(
        appBar: AppBar(
          title: Text('demande de Configuration '),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('demandeInputs').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final documents = snapshot.data!.docs;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('CIN')),
                  DataColumn(label: Text('pH')),
                  DataColumn(label: Text('Conductivity')),
                  DataColumn(label: Text('Oxygen')),
                  DataColumn(label: Text('Temperature')),
                  DataColumn(label: Text('Action')),
                ],
                rows: documents.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final configurationId = doc.id;

                  return DataRow(
                    cells: [
                      DataCell(Text(data['name'] ?? '')),
                      DataCell(Text(data['lastname'] ?? '')),
                      DataCell(Text(data['cin'] ?? '')),
                      DataCell(Text(data['pH'].toString())),
                      DataCell(Text(data['conductivity'].toString())),
                      DataCell(Text(data['oxygen'].toString())),
                      DataCell(Text(data['temperature'].toString())),

                      DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (!configurationStates.containsKey(configurationId)) {
                                    configurationStates[configurationId] = true;
                                  }
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  configurationStates.containsKey(configurationId) && configurationStates[configurationId] == true
                                      ? Colors.green
                                      : (currentFilter == FilterState.Rejected ? Colors.red : Colors.grey),
                                ),
                              ),
                              child: Text('Accepté'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (!configurationStates.containsKey(configurationId)) {
                                    configurationStates[configurationId] = false;
                                  }
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  configurationStates.containsKey(configurationId) && configurationStates[configurationId] == false
                                      ? Colors.red
                                      : (currentFilter == FilterState.Accepted ? Colors.green : Colors.grey),
                                ),
                              ),
                              child: Text('Rejeté'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (configurationStates.containsKey(configurationId)) {
                                    configurationStates.remove(configurationId);
                                  }
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  !configurationStates.containsKey(configurationId) ? Colors.grey : Colors.grey,
                                ),
                              ),
                              child: Text('Non traité'),
                            ),
                          ],
                        ),
                      ),

                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      );
    }
  }
}