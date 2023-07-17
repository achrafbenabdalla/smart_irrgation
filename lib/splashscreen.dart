import 'dart:io';

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter_tes/constants.dart';
import 'verify-log.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
        "assets/images/logo.png",
      ),
      logoWidth: 200,
      title: Text(
        "Smart Irrigation",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: bgColor,
      loaderColor: primaryColor,
      showLoader: true,
      loadingText: Text("Loading..."),
      navigator: VerificationPage(),
      durationInSeconds: 2,
    );
  }
}
