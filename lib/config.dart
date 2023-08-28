// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_tes/sign-in.dart';
import 'package:provider/provider.dart';
import 'package:selectable_box/selectable_box.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tes/controllers/MenuAppController.dart';
import 'screens/main/main_screen.dart';
import 'constants.dart';


class Config extends StatefulWidget {
  const Config({Key? key});

  @override
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  bool isSelected = false;
  bool temp = false;
  bool cond = false;
  bool oxy = false;
  bool ph = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Config'),
        backgroundColor: Color(0xff259e73),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      ));
            },
          )
        ],
      ),
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Configuration',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text('Veuillez sélectionner la configuration souhaitée',
                    style: TextStyle(fontSize: 22)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableBox(
                      height: 200,
                      width: 250,
                      color: secondaryColor,
                      selectedColor: Color(0xff259e73),
                      borderColor: Color(0xff259e73),
                      selectedBorderColor: Color(0xff259e73),
                      borderWidth: 2,
                      borderRadius: 20,
                      padding: const EdgeInsets.all(8),
                      animationDuration: const Duration(milliseconds: 200),
                      opacity: 1,
                      selectedOpacity: 1,
                      unSelectedIcon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.grey,
                      ),
                      showCheckbox: false,
                      onTap: () {
                        setState(() {
                          temp = !temp;
                        });
                      },
                      isSelected: temp,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.thermostat_outlined,
                              size: 60,
                              color: temp == false
                                  ? Color(0xff259e73)
                                  : Colors.white,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                'Temperature',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: temp == true ? Colors.white : null),
                              ),
                            )
                          ],
                        ),
                      )),
                  SelectableBox(
                      height: 200,
                      width: 250,
                      color: secondaryColor,
                      selectedColor: Color(0xff259e73),
                      borderColor: Color(0xff259e73),
                      selectedBorderColor: Color(0xff259e73),
                      borderWidth: 2,
                      borderRadius: 20,
                      padding: const EdgeInsets.all(8),
                      animationDuration: const Duration(milliseconds: 200),
                      opacity: 1,
                      selectedOpacity: 1,
                      unSelectedIcon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.grey,
                      ),
                      showCheckbox: false,
                      onTap: () {
                        setState(() {
                          cond = !cond;
                        });
                      },
                      isSelected: cond,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bolt,
                              size: 60,
                              color: cond == false
                                  ? Color(0xff259e73)
                                  : Colors.white,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Conductivité',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: cond == true ? Colors.white : null),
                            )
                          ],
                        ),
                      )),
                  SelectableBox(
                      height: 200,
                      width: 250,
                      color: secondaryColor,
                      selectedColor: Color(0xff259e73),
                      borderColor: Color(0xff259e73),
                      selectedBorderColor: Color(0xff259e73),
                      borderWidth: 2,
                      borderRadius: 20,
                      padding: const EdgeInsets.all(8),
                      animationDuration: const Duration(milliseconds: 200),
                      opacity: 1,
                      selectedOpacity: 1,
                      unSelectedIcon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.grey,
                      ),
                      showCheckbox: false,
                      onTap: () {
                        setState(() {
                          oxy = !oxy;
                        });
                      },
                      isSelected: oxy,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/oxygen-icon.svg', // Replace with the actual path to your icon file
                              height: 48,
                              width: 48,
                              color: oxy == false
                                  ? Color(0xff259e73)
                                  : Colors.white,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                'Oxygène dissous',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: oxy == true ? Colors.white : null),
                              ),
                            )
                          ],
                        ),
                      )),
                  SelectableBox(
                      height: 200,
                      width: 250,
                      color: secondaryColor,
                      selectedColor: Color(0xff259e73),
                      borderColor: Color(0xff259e73),
                      selectedBorderColor: Color(0xff259e73),
                      borderWidth: 2,
                      borderRadius: 20,
                      padding: const EdgeInsets.all(8),
                      animationDuration: const Duration(milliseconds: 200),
                      opacity: 1,
                      selectedOpacity: 1,
                      unSelectedIcon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.grey,
                      ),
                      showCheckbox: false,
                      onTap: () {
                        setState(() {
                          ph = !ph;
                        });
                      },
                      isSelected: ph,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/ph.svg', // Replace with the actual path to your icon file
                              height: 48,
                              width: 48,
                              color: ph == false
                                  ? Color(0xff259e73)
                                  : Colors.white,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Niveau de PH',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: ph == true ? Colors.white : null),
                            )
                          ],
                        ),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff259e73),
                        fixedSize: Size(150, 40)),
                    onPressed: () async {
                      final CollectionReference postsRef =
                          FirebaseFirestore.instance.collection('users');
                      User? user = FirebaseAuth.instance.currentUser;
                      String userID = user!.uid;

                      await postsRef.doc(userID).set({
                        "tempurature": temp,
                        "conductivity": cond,
                        "oxygen": oxy,
                        "ph": ph
                      }).then((value) => Navigator.push(
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
                          ));
                    },
                    child: Text('Confirmer', style: TextStyle(fontSize: 19))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
