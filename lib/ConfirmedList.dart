import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tes/sign-in.dart';

class ConfirmedList extends StatefulWidget {
  const ConfirmedList({Key? key}) : super(key: key);

  @override
  State<ConfirmedList> createState() => _ConfirmedListState();
}

class _ConfirmedListState extends State<ConfirmedList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('validatedUsers').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            // Create a list of DataRow widgets to represent each user
            List<DataRow> rows = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

              return DataRow(
                cells: [
                  DataCell(Text(userData['name'] ?? '')),
                  DataCell(Text(userData['lastName'] ?? '')),
                  DataCell(Text(userData['cin'] ?? '')),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {
                        // Handle user connection here
                        // For example, you can open a login dialog
                        _showLoginDialog(context);
                      },
                      child: Text("Connect"),
                    ),
                  ),
                ],
              );
            }).toList();

            // Create the DataTable with columns and rows
            return DataTable(
              columns: [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Last Name')),
                DataColumn(label: Text('CIN')),
                DataColumn(label: Text('Action')),
              ],
              rows: rows,
            );
          },
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    // Show a login dialog here
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Log In"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add login form fields here
              // For example, TextFields for email and password
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _onButtonPressed(context);
                // Handle login logic here
                // For example, call a login function
              },
              child: Text("Log In"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
  void _onButtonPressed(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
    );

  }
}
