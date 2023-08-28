import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tes/PermissionDeniedPage.dart';
import 'package:flutter_tes/dash.dart';
import 'package:flutter_tes/showInfoUser.dart';

class ListOfDemandeSensorsPage extends StatelessWidget {
  final bool isAdmin;

  ListOfDemandeSensorsPage({required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Demand de Sensors'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('demandesensors').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No data available.'),
              );
            }

            List<DataRow> dataRows = snapshot.data!.docs.map((document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              String etat = data['etat'] ?? 'N/A';

              return DataRow(
                cells: [
                  DataCell(Text(data['name'] ?? 'N/A')),
                  DataCell(Text(data['lastName'] ?? 'N/A')),
                  DataCell(Text(data['password'] ?? 'N/A')),
                  DataCell(Text(data['includepH']?.toString() ?? 'N/A')),
                  DataCell(Text(data['includeOxygen']?.toString() ?? 'N/A')),
                  DataCell(Text(data['includeConductivity']?.toString() ?? 'N/A')),
                  DataCell(Text(data['includeTemperature']?.toString() ?? 'N/A')),
                  DataCell(Text(data['etat'] ?? 'N/A')),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('demandesensors')
                                .doc(document.id)
                                .delete();
                          },
                        ),
                        if (isAdmin)
                          ElevatedButton(
                            onPressed: () async {
                              String newEtat = 'accepted';
                              if (etat == 'accepted') {
                                newEtat = 'rejected';
                              }

                              await FirebaseFirestore.instance
                                  .collection('demandesensors')
                                  .doc(document.id)
                                  .update({'etat': newEtat});
                            },
                            child: Text(etat == 'accepted' ? 'Reject' : 'Accept'),
                            style: ElevatedButton.styleFrom(
                              primary: etat == 'accepted' ? Colors.red : Colors.green,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),

                      ],
                    ),
                  ),
                ],
              );
            }).toList();

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Last Name')),
                    DataColumn(label: Text('password')),
                    DataColumn(label: Text('pH')),
                    DataColumn(label: Text('Oxygen')),
                    DataColumn(label: Text('Conductivity')),
                    DataColumn(label: Text('Temperature')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: dataRows,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
