// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_tes/screens/main/configmain.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'controllers/MenuAppController.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late bool _passwordVisible;
  @override
  void initState() {
    _passwordVisible = false;
    // TODO: implement initState
    super.initState();
  }

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Color(0xff259e73), // Adjust the color of the app bar
      ),
      body: Center(
        child: Container(
          height: 580,
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
                    width: 250,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    'Sign up enter your full name,email and password',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextField(
                      controller: _nameController,
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
                          labelText: 'Full Name',
                          hintText: 'Enter Your Full Name',
                          labelStyle: TextStyle(
                            color: Color(0xff259e73),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
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
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 19),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff259e73),
                      fixedSize: Size(120, 40)),
                  onPressed: () async {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text);
                      String userId = userCredential.user!.uid;
                      final CollectionReference postsRef =
                          FirebaseFirestore.instance.collection('users');

                      await postsRef.doc(userId).set({
                        "username": _nameController.text,
                        "conductivity": false,
                        "oxygen": false,
                        "tempurature": false,
                        "ph": false
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }

                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? user) {
                      if (user == null) {
                        print('User is currently signed out!');
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                        create: (context) =>
                                            MenuAppController(),
                                      ),
                                    ],
                                    child: ConfigMainScreen(),
                                  )),
                        );
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
