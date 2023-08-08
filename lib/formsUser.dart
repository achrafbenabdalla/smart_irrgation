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

  final controllerName=TextEditingController();
  final controllerLastName=TextEditingController();
  final controllerCIN=TextEditingController();
  final controllerPassword=TextEditingController();
  final controllerConfirmPass=TextEditingController();

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

  void _showSuccessDialog() {
    // Here you can add the logic to create a new user or save the password
    // For the purpose of this example, we will just show a success message.
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

          title: Text('List of User')
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
                          color: Colors.white),
                    ),
                  ),



                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Text(
                      'Sign in using your email and password',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: TextField(
                        controller: controllerName,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Color(0xff259e73)), //<-- SEE HERE
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 3, color: Color(0xff259e73)),
                            ),
                            labelText: 'Name',
                            hintText: 'Enter Your Name',
                            labelStyle: TextStyle(
                              color: Color(0xff259e73),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xff259e73),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: TextField(
                        controller: controllerLastName,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Color(0xff259e73)), //<-- SEE HERE
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 3, color: Color(0xff259e73)),
                            ),
                            labelText: 'LastName',
                            hintText: 'Enter Your LastName',
                            labelStyle: TextStyle(
                              color: Color(0xff259e73),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xff259e73),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: TextField(
                        controller: controllerCIN,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Color(0xff259e73)), //<-- SEE HERE
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 3, color: Color(0xff259e73)),
                            ),
                            labelText: 'CIN',
                            hintText: 'Enter Your CIN',
                            labelStyle: TextStyle(
                              color: Color(0xff259e73),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xff259e73),
                            )),
                      ),
                    ),
                  ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: TextFormField(
                        controller: controllerPassword,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color(0xff259e73),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Color(0xff259e73)),
                          ),
                          labelText: 'Password',
                          hintText: 'Enter Your Password',
                          labelStyle: TextStyle(
                            color: Color(0xff259e73),
                          ),
                          // Add a prefixIcon that is an IconButton to toggle the password visibility
                          prefixIcon: IconButton(
                            icon: Icon(
                              // Based on _passwordVisible state choose the icon
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Color(0xff259e73),
                            ),
                            onPressed: () {
                              // Update the state to toggle the visibility of the password
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        // Use obscureText property to hide or show the password based on the _passwordVisible state
                        obscureText: !_passwordVisible,
                      ),

                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: TextFormField(
                        controller: controllerConfirmPass,
                        validator: (value) {
                          if (value != controllerPassword.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color(0xff259e73),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Color(0xff259e73)),
                          ),
                          labelText: 'Confirm Password',
                          hintText: 'Enter Your Confirmed Password',
                          labelStyle: TextStyle(
                            color: Color(0xff259e73),
                          ),

                          // Add a prefixIcon that is an IconButton to toggle the password visibility
                          prefixIcon: IconButton(
                            icon: Icon(
                              // Based on _passwordVisible state choose the icon
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Color(0xff259e73),
                            ),
                            onPressed: () {
                              // Update the state to toggle the visibility of the password
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        // Use obscureText property to hide or show the password based on the _passwordVisible state
                        obscureText: !_passwordVisible,
                      ),

                    ),
                  ),


                  SizedBox(
                    height: 50,
                  ),


                  Positioned(
                    top: 20,
                    right: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        final userAdmin =UserAdmin(
                            Name:controllerName.text,
                            LastName:controllerLastName.text,
                            CIN:int.parse(controllerCIN.text),
                            Password:controllerPassword.text,
                            ConfirmPass:controllerConfirmPass.text
                        );
                        if (_formKey.currentState!.validate()) {

                          createUser(userAdmin);
                          Navigator.pop(context);
                          _showSuccessDialog(); // If passwords match, show success dialog
                        } else {
                          _showPasswordMismatchDialog(); // If passwords do not match, show error dialog
                        }

                      },
                      child: Text('ADD NEW USER'),
                    ),
                  ),  SizedBox(
                    height: 20,
                  ),

                  InkWell(
                    onTap: () {
                     Navigator.pop(context,UserList());


                      }
                      // Add the logic to handle the "Back" button tap here
                      // For example, you can use Navigator.pop(context) to go back to the previous screen.
    ,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(400),
                        color: Colors.red,
                      ),
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),


                ],
              ),
            ),
              ]))))));
  }
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
