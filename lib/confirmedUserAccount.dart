import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tes/ConfirmedList.dart';
import 'package:flutter_tes/UserList.dart';

class ConfirmedUserAccount extends StatelessWidget {
  final String password;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController cinController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  ConfirmedUserAccount({
    required this.Name,
    required this.LastName,
    required this.CIN,
    required this.password


  }) {
    nameController.text = Name;
    lastNameController.text = LastName;
    cinController.text = CIN;
    passwordController.text = password;
  }

  void _submitUserInfo(BuildContext context) async {
    String name = nameController.text;
    String lastName = lastNameController.text;
    String cin = cinController.text;
    String password = passwordController.text;

    // Create a new Firestore document in the validatedUsers collection
    await FirebaseFirestore.instance.collection('validatedUsers').add({
      'name': name,
      'lastName': lastName,
      'cin': cin,
      'password': password,
      'etat': "null",
    });
    Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => UserList()));


  }
    // Optionally, you can show a confirmation message or navigate back to the previous screen
   // _onButtonPressed(context);  }
 //// void _onButtonPressed(BuildContext context) async {
  //  final result = await Navigator.push(
    //  context,
   //   MaterialPageRoute(builder: (context) => ConfirmedList()),
   // );


  final String Name;
  final String LastName;
  final String CIN;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Name:"),
                        SizedBox(width: 8),
                        Text(Name),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text("Last Name:"),
                        SizedBox(width: 8),
                        Text(LastName),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text("CIN:"),
                        SizedBox(width: 8),
                        Text(CIN),
                      ],
                    ),
                    Row(
                      children: [
                        Text("password:"),
                        SizedBox(width: 8),
                        Text(password),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _submitUserInfo(context),
              child: Text("confirm the Submission"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _submitUserInfo(context),
              child: Text("Go To The Dashobard" ),
            ),
          ],
        ),
      ),
    );
  }
}
