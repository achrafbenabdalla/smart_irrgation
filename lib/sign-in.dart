import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tes/DahUser.dart';
import 'package:flutter_tes/formsUser.dart';
import 'package:flutter_tes/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_tes/showInfoUser.dart';
import 'PermissionDeniedPage.dart';
import 'WaitingValidationPage.dart';
import 'dash.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late bool _passwordVisible;

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController cinController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isAdmin = false;
  bool isAccepted = false;

  late bool includepH ;
  late bool includeConductivity ;
  late bool includeOxygen ;
  late bool includeTemperature;

  late String name;
  late String lastName;
  late String cin;
  late String password;


  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign-In an existing user'),
        backgroundColor: Color(0xff259e73),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: 620,
            width: 450,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              //color: secondaryColor,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DrawerHeader(
                    child: GestureDetector(
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 250,
                        height: 150,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle Home navigation
                        },
                        child: Text('Sign in '),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => formsUser(
                                   ),
                            ),
                          );
                          // Handle Profile navigation
                        },
                        child: Text('Sign Up '),
                      ),

                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: TextField(
                        controller: nameController,
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
                            Icons.person,
                            color: Color(0xff259e73),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: lastNameController,
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
                        labelText: 'Last Name',
                        hintText: 'Enter Your Last Name',
                        labelStyle: TextStyle(
                          color: Color(0xff259e73),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0xff259e73),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: passwordController,
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
                        hintText: 'Enter Your Last Password',
                        labelStyle: TextStyle(
                          color: Color(0xff259e73),
                        ),
                        prefixIcon: Icon(
                          Icons.password,
                          color: Color(0xff259e73),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 19),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff259e73),
                      fixedSize: Size(220, 50),
                    ),
                    onPressed: () async {
    final name = nameController.text;
    final lastName = lastNameController.text;
    final password = passwordController.text;

    QuerySnapshot validatedUserSnapshot =
    await FirebaseFirestore.instance
        .collection('validatedUsers')
        .where('name', isEqualTo: name)
        .where('lastName', isEqualTo: lastName)
        .where('password', isEqualTo: password)
        .get();

    if (validatedUserSnapshot.size > 0) {
    final validatedUserData = validatedUserSnapshot.docs[0]
        .data() as Map<String, dynamic>;
    final etat = validatedUserData['etat'];

    if (etat == 'null') {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => ShowUserDetails(
    name: nameController.text,
    cin: cinController.text,
    lastName: lastNameController.text,
    password: passwordController.text,
    isAdmin: isAdmin,
    isAccepted: isAccepted,
    includepH: false,
    includeOxygen: false,
    includeConductivity: false,
    includeTemperature: false,
    ),
    ),
    );
    }
    QuerySnapshot demandSnapshot = await FirebaseFirestore.instance
        .collection('demandesensors')
        .where('name', isEqualTo: name)
        .where('lastName', isEqualTo: lastName)
        .where('password', isEqualTo: password)
        .get();
    // Check if sensor request exists
    if (demandSnapshot.size > 0) {
    final demandData = demandSnapshot.docs[0].data() as Map<String, dynamic>;
    final etat = demandData['etat'] ?? 'N/A';
    if (etat == 'accepted') {
    final includeTemperatureValue =
    validatedUserData['includeTemperature'] ?? false;
    final includeOxygenValue = validatedUserData['includeOxygen'] ?? false;
    final includepHValue = validatedUserData['includepH'] ?? false;
    final includeConductivityValue =
    validatedUserData['includeConductivity'] ?? false;

    Navigator.pushReplacement(
    context,
    MaterialPageRoute(
    builder: (context) => DahUser(
    name: name,
    lastName: lastName,
    password: password,
    includeTemperature: includeTemperatureValue,
    includeConductivity: includeConductivityValue,
    includeOxygen: includeOxygenValue,
    includepH: includepHValue,
    cin: '', // Set this based on your logic
    ),
    ),
    );
    } else if (etat == 'rejected') {
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(
    builder: (context) => PermissionDeniedPage(),
    ),
    );
    }
    }
    }})                ],
              ),
            ),
          ),
        ),
      ),

    );  }

                  }
