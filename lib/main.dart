import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tes/UserList.dart';
import 'package:flutter_tes/authAdmin.dart';
import 'package:flutter_tes/screens/dashboard/config.dart';
import 'package:flutter_tes/constants.dart';
import 'package:flutter_tes/controllers/MenuAppController.dart';
import 'package:flutter_tes/mainpage.dart';
import 'package:flutter_tes/screens/main/main_screen.dart';
import 'package:flutter_tes/sign-in-admin.dart';
import 'package:flutter_tes/sign-in.dart';
import 'package:flutter_tes/splashscreen.dart';
import 'package:flutter_tes/verify-log.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Irrigation',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home:  AuthAdminPage(name: '', mail: '', password: '',),
    );
  }
}
