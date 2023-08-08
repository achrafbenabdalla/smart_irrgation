// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_tes/ConfirmedList.dart';
import 'package:flutter_tes/UserList.dart';
import 'package:flutter_tes/sign-in-admin.dart';
import 'package:flutter_tes/verify-log.dart';
import 'package:selectable_box/selectable_box.dart';
import 'constants.dart';

class mainpage extends StatefulWidget {
  const mainpage({Key? key});

  @override
  _mainpageState createState() => _mainpageState();
}

class _mainpageState extends State<mainpage> {
  @override
  void initState() {
    super.initState();
  }

  bool user = false;
  bool admin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SELECT PAGE '),
          backgroundColor: Color(0xff259e73), // Adjust the color of the app bar
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SelectableBox(
                        height: 300,
                        width: 300,
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
                            user = !user;
                            admin = !user;
                          });
                        },
                        isSelected: user,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                size: 60,
                                color: user == false
                                    ? Color(0xff259e73)
                                    : Colors.white,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  'user',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          user == true ? Colors.white : null),
                                ),
                              )
                            ],
                          ),
                        )),
                    SelectableBox(
                        height: 300,
                        width: 300,
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
                            admin = !admin;
                            user = !admin;
                          });
                        },
                        isSelected: admin,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.admin_panel_settings_outlined,
                                size: 60,
                                color: admin == false
                                    ? Color(0xff259e73)
                                    : Colors.white,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  'admin',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          admin == true ? Colors.white : null),
                                ),
                              )
                            ],
                          ),
                        ))
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff259e73),
                      fixedSize: Size(150, 40)),
                  onPressed: () async {
                    if (user == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConfirmedList()),
                      );
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserList()));
                    }
                  },
                  child: Text('Confirmer', style: TextStyle(fontSize: 19))),
            )
          ],
        )));
  }
}
