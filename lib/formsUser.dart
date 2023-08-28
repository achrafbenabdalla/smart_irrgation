import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tes/UserList.dart';
import 'package:flutter_tes/constants.dart';

class formsUser extends StatefulWidget {
  const formsUser({Key? key}) : super(key: key);

  @override
  State<formsUser> createState() => _formsUserState();
}

class _formsUserState extends State<formsUser> {
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false; // Add this line to hold the password visibility state

  final controllerName = TextEditingController();
  final controllerLastName = TextEditingController();
  final controllerCIN = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerConfirmPass = TextEditingController();

  void _showPasswordMismatchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Passwords Mismatch"),
          content: Text("The passwords you entered do not match. Please try again."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showWaitingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return AlertDialog(
          title: Text("Processing Admission"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // Show a loading spinner
              SizedBox(height: 16),
              Text("Please wait while your admission is being processed."),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Passwords match. New user added successfully."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff259e73), // Adjust the color of the app bar
          title: Text('List of User'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back when the arrow button is pressed
            },
          ),
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: secondaryColor,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Text(
                      'ADD NEW USER ',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Text(
                      'Sign in using your email and password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Container(
                    width: 300, // Set the desired width for the input fields
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: controllerName,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(0xff259e73),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(0xff259e73),
                              ),
                            ),
                            labelText: 'Name',
                            hintText: 'Enter Your Name',
                            labelStyle: TextStyle(
                              color: Color(0xff259e73),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xff259e73),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: controllerLastName,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(0xff259e73),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(0xff259e73),
                              ),
                            ),
                            labelText: 'LastName',
                            hintText: 'Enter Your LastName',
                            labelStyle: TextStyle(
                              color: Color(0xff259e73),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xff259e73),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: controllerCIN,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(0xff259e73),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(0xff259e73),
                              ),
                            ),
                            labelText: 'CIN',
                            hintText: 'Enter Your CIN',
                            labelStyle: TextStyle(
                              color: Color(0xff259e73),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xff259e73),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: controllerPassword,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(0xff259e73),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(0xff259e73),
                              ),
                            ),
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: controllerConfirmPass,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(0xff259e73),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(0xff259e73),
                              ),
                            ),
                            labelText: 'Confirm Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (controllerCIN.text.length != 8 || controllerPassword.text != controllerConfirmPass.text) {
                        _showCINLengthErrorDialog(context);
                      } else {
                        final userAdmin = UserAdmin(
                          Name: controllerName.text,
                          LastName: controllerLastName.text,
                          CIN: int.parse(controllerCIN.text),
                          Password: controllerPassword.text,
                          ConfirmPass: controllerConfirmPass.text,
                        );

                        createUser(userAdmin);
                        Navigator.pop(context);
                        _showSuccessDialog();
                      }
                    },
                    child: Text('ADD NEW USER'),
                  ),
                  SizedBox(height: 16),
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.pop(context); // Navigate back when the arrow button is pressed
                    },
                  ),
                ]))))));
  }
}

class _showCINLengthErrorDixalog {
}

// Function to add a new user to Firestore
Future<void> createUser(UserAdmin userAdmin) async {
  try {
    // Convert the User object to a Map for Firestore
    Map<String, dynamic> dataMap = {
      'Name': userAdmin.Name,
      'LastName': userAdmin.LastName,
      'CIN': userAdmin.CIN,
      'Password': userAdmin.Password,
      'ConfirmPass': userAdmin.ConfirmPass,
      'isValid': false, // Set isValid to false for new registrations

    };
    // Specify the collection name where you want to store the user data
    String collectionName = 'userAdmin'; // You can change 'users' to your desired collection name

    // Add data to Firestore collection
    await FirebaseFirestore.instance.collection(collectionName).add(dataMap);

    // Optionally, you can add a success message or perform any additional actions
    // after adding the user to Firestore.

  } catch (e) {
    print("Error creating user: $e");
  }
}


class UserAdmin {
  final String Name;
  final String LastName;
  final int CIN;
  final String Password;
  final String ConfirmPass;

  UserAdmin({
    required this.Name,
    required this.LastName,
    required this.CIN,
    required this.Password,
    required this.ConfirmPass,
  });
}
void _showCINLengthErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Verify cin or Password"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}