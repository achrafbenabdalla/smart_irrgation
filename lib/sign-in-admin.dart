// ignore_for_file: prefer_const_constructors


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_tes/forget_pw.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tes/splashscreen.dart';

import 'constants.dart';



class SignInAdmin extends StatefulWidget {
  const SignInAdmin({Key? key});

  @override
  _SignInAdminState createState() => _SignInAdminState();
}

class _SignInAdminState extends State<SignInAdmin> {
  dynamic data;
  Map<String, dynamic> settingsData = {};
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;

    super.initState();
  }

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        backgroundColor: Color(0xff259e73), // Adjust the color of the app bar
      ),
      body: Center(
        child: Container(
          height: 620,
          width: 450,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: secondaryColor,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DrawerHeader(
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 250, // Set the desired width
                    height: 150, // Set the desired height
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Text(
                    'Sign In',
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
                                color: Color(0xff259e73)), //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xff259e73)),
                          ),
                          labelText: 'Email',
                          hintText: 'Enter Your Email',
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
                  child: TextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: !_passwordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Color(0xff259e73)), //<-- SEE HERE
                      ),
                      labelText: 'Password',
                      hintText: 'Enter Your Password',
                      labelStyle: TextStyle(
                        color: Color(0xff259e73),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xff259e73),
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
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
                        borderSide:
                            BorderSide(width: 3, color: Color(0xff259e73)),
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
                                  builder: (context) => forget_pw()),
                            );
                          },
                          child: Text('forget password ?',
                              style: TextStyle(color: Color(0xff259e73)))),
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
                      fixedSize: Size(220, 50)),
                  onPressed: () async {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? user) async {
                      if (user == null) {
                        print('User is currently signed out!');
                      } else {
                        print('ur not admin');
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          var userID = user.uid;
                          DocumentSnapshot<Map<String, dynamic>>
                              documentSnapshot = await FirebaseFirestore
                                  .instance
                                  .collection('users')
                                  .doc(userID)
                                  .get();

                          if (documentSnapshot.exists) {
                            setState(() {
                              settingsData = documentSnapshot.data()!;
                            });
                            print(settingsData);
                          }
                        }

                        print(settingsData['role']);
                        if (settingsData['role'] == 'admin') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SplashPage()),
                          );
                        } else {
                          print('ur not admin');
                        }
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
