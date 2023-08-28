import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tes/ConfigurationList.dart';
import 'package:flutter_tes/showInfoUser.dart'; // Import the user info screen

class DashUser extends StatelessWidget {
  String? get authenticatedUserId => null;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Fetch authenticated user information from Firestore
                final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                    .collection('validatedUsers')
                    .doc(authenticatedUserId) // Query the authenticated user by their ID
                    .get();

                if (userSnapshot.exists) {
                  final userData = userSnapshot.data() as Map<String, dynamic>;
                  final name = userData['name'];
                  final lastName = userData['lastName'];
                  final cin = userData['cin'];

                  // Navigate to the user info screen with the retrieved user information
                  Navigator.pop(context);

                } else {
                  // Handle user not found or any other error
                }
              }, child: Text("Voir mon profil"),            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Fetch authenticated user information from Firestore
                final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                    .collection('validatedUsers')
                    .doc(authenticatedUserId) // Query the authenticated user by their ID
                    .get();

                if (userSnapshot.exists) {
                  final userData = userSnapshot.data() as Map<String, dynamic>;
                  final name = userData['name'];
                  final lastName = userData['lastName'];
                  final cin = userData['cin'];
                  Navigator.pop(context);

                  // Navigate to the user info screen with the retrieved user information
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfigurationList(
                        name: name,
                        lastName: lastName,
                        cin: cin, isAdmin: false,
                      ),
                    ),
                  );
                } else {
                  // Handle user not found or any other error
                }
              }, child: Text("Config"),            ),

            ElevatedButton(
              onPressed: () {
                // Add your button logic here
              },
              child: Text('Click Me'),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardBox extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback onTap;

  const DashboardBox({
    required this.color,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

