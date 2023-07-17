// ignore_for_file: prefer_const_constructors


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tes/sign-in.dart';


import 'constants.dart';

class forget_pw extends StatefulWidget {
  const forget_pw({Key? key});

  @override
  _forget_pwState createState() => _forget_pwState();
}

class _forget_pwState extends State<forget_pw> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController _emailController = new TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    super.dispose();
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Password reset link sent! check your email"),
              backgroundColor: Color(0xFF212332),
              shadowColor: Color(0xff259e73),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    },
                    child: Text('Close'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF259E73),
                    ),
                  ),
                ),
              ],
            );
          });
    } on FirebaseAuthMultiFactorException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
              backgroundColor: Color(0xFF212332),
              shadowColor: Color(0xff259e73),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
                  child: Text(
                    'Enter Your Email We Will Send You a Passowrd Rest link',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
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
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 19),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff259e73),
                      fixedSize: Size(200, 50)),
                  onPressed: resetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
