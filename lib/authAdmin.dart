import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tes/sign-in.dart';

import 'DashboardAdmin.dart';
import 'forget_pw.dart';

class AuthAdminPage extends StatefulWidget {
  const AuthAdminPage({
    Key? key,
    required this.name,
    required this.mail,
    required this.password,
  }) : super(key: key);

  final String name;
  final String mail;
  final String password;

  @override
  _SignInAdminState createState() => _SignInAdminState();
}

class _SignInAdminState extends State<AuthAdminPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _NameController;

  late bool _passwordVisible;
  bool _validateEmail = false; // Add this line

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _NameController = TextEditingController();

    _passwordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _NameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In ADMIN'),
        backgroundColor: Color(0xff259e73),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Add your navigation logic here
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => SignIn(),),);
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          height: 620,
          width: 450,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DrawerHeader(
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 250,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Text(
                    'Sign In ADMIN',
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
                      controller: _emailController,
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
                        labelText: 'Email',
                        hintText: 'Enter Your Email',
                        labelStyle: TextStyle(
                          color: Color(0xff259e73),
                        ),

                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xff259e73),
                        ),
                        errorText: _validateEmail
                            ? 'Enter a valid email in the format admi@admi.com'
                            : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _validateEmail = !isValidEmailFormat(value);
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: !_passwordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Color(0xff259e73),
                        ),
                      ),
                      labelText: 'Password',
                      hintText: 'Enter Your Password',
                      labelStyle: TextStyle(
                        color: Color(0xff259e73),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xff259e73),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      prefixIcon: Icon(
                        Icons.password,
                        color: Color(0xff259e73),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Color(0xff259e73),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 65),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => forget_pw(),
                            ),
                          );
                        },
                        child: Text(
                          'forget password ?',
                          style: TextStyle(color: Color(0xff259e73)),
                        ),
                      ),
                    ],
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
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      String errorMessage = ''; // Initialize the error message variable

                      // Check if the provided credentials match the predefined admin credentials
                      if (email == 'soulaima@gmail.com' && password == 'soulaima') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardPageAdmin(
                              AuthAdmin(
                                name: widget.name,
                                mail: email,
                                password: password,
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Set the error message
                        errorMessage = 'Invalid admin credentials.';
                      }

                      // Show an error message if applicable
                      if (errorMessage.isNotEmpty) {
                        // Print the error message to the console
                        print(errorMessage);

                        // Show the error dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Access Denied'),
                            content: Text(errorMessage),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }})              ],
            ),
          ),
        ),
      ),
    );
  }

  void createAdminDocument(AuthAdmin admin) async {
    try {
      await FirebaseFirestore.instance.collection('AuthAdmin').add({
        'Name': admin.name,
        'mail': admin.mail,
        'password': admin.password,
      });
      print('Admin document created successfully.');
    } catch (e) {
      print('Error creating admin document: $e');
    }
  }

  bool isValidEmailFormat(String email) {
    // Define your custom email format here, e.g., admi@admi.com
    RegExp emailRegExp = RegExp(r'^admi@admi\.com$');
    return emailRegExp.hasMatch(email);
  }
}

class AuthAdmin {
  final String name;
  final String mail;
  final String password;

  AuthAdmin({
    required this.name,
    required this.mail,
    required this.password,
  });
}
