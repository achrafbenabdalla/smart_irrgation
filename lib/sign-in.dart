// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tes/config.dart';
import 'package:flutter_tes/forget_pw.dart';
import 'package:flutter_tes/screens/main/main_screen.dart';
import 'package:flutter_tes/sign-up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:flutter_tes/controllers/MenuAppController.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    // TODO: implement initState
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
                                    child: MainScreen(),
                                  )),
                        );
                      }
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                GoogleAuthButton(
                  onPressed: () async {
                    GoogleSignIn _googleSignIn =
                        GoogleSignIn(scopes: ['email']);

                    GoogleSignInAccount? googleAccount =
                        await _googleSignIn.signIn();
                    if (googleAccount != null) {
                      GoogleSignInAuthentication googleAuth =
                          await googleAccount.authentication;
                      OAuthCredential credential =
                          GoogleAuthProvider.credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      );
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithCredential(credential);
                      User? user = userCredential.user;
                      if (user != null) {
                        String uid = user.uid;

                        // Create a document in Firestore with the same UID
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .update({
                          'email': user.email,
                          // Add any additional user data you want to store
                        });

                        // Navigate to the main screen or perform any necessary operations
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  create: (context) => MenuAppController(),
                                ),
                              ],
                              child: MainScreen(),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  style: AuthButtonStyle(
                      buttonColor: Color(0xff259e73),
                      width: 220,
                      height: 50,
                      textStyle: TextStyle(fontSize: 15, color: Colors.white)),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont't have an account ?"),
                    SizedBox(
                      width: 5,
                    ),
                    new InkWell(
                        child: new Text(
                          'Sign Up',
                          style: TextStyle(color: Color(0xff259e73)),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        })
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
