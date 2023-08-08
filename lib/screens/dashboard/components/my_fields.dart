import 'dart:html';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tes/sign-in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tes/models/MyFiles.dart';
import 'package:flutter_tes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../constants.dart';
import 'file_info_card.dart';

class MyFiles extends StatefulWidget {
  MyFiles({Key? key}) : super(key: key);

  @override
  _MyFilesState createState() => _MyFilesState();
}

class _MyFilesState extends State<MyFiles> {
  dynamic data;
  String tempData = "";
  Map<String, dynamic> settingsData = {};
  List<CloudStorageInfo> demoMyFiles = [];

  @override
  void initState() {
    super.initState();
    fetchSettingsData().then((value) => fillData());
  }

  Future<void> fetchSettingsData() async {
    User? user = FirebaseAuth.instance.currentUser;
    var userID = user!.uid;

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();

    if (documentSnapshot.exists) {
      setState(() {
        settingsData = documentSnapshot.data()!;
      });
      print(settingsData);
    }
  }

  Future<void> fillData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('data');
    ref.onValue.listen((event) {
      final data2 = event.snapshot.value;
      updateData(data2);
    });
  }

  void updateData(data) {
    setState(() {
      this.data = data;

      demoMyFiles = fillList();
      if (data != null) {
        if (settingsData['tempurature'] == true) {
          if (data['temp'] > 50) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    icon: Icon(
                      Icons.error_outline_rounded,
                    ),
                    content: Text("the temperateur is too hight"),
                    backgroundColor: Color(0xFF212332),
                    shadowColor: Color.fromARGB(255, 143, 8, 8),
                    actions: [
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Close'),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 143, 3, 3),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          }
        }

        // if (settingsData['oxygen'] == true) {
        //   if (data['oxy'] > 70) {
        //     showDialog(
        //         context: context,
        //         builder: (context) {
        //           return AlertDialog(
        //             icon: Icon(
        //               Icons.error_outline_rounded,
        //             ),
        //             content: Text(
        //               "The Oxygéne level  is too hight",
        //             ),
        //             backgroundColor: Color(0xFF212332),
        //             shadowColor: Color.fromARGB(255, 143, 8, 8),
        //             actions: [
        //               Center(
        //                 child: ElevatedButton(
        //                   onPressed: () {
        //                     Navigator.pop(context);
        //                   },
        //                   child: Text('Close'),
        //                   style: ElevatedButton.styleFrom(
        //                     primary: Color.fromARGB(255, 143, 3, 3),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           );
        //         });
        //   }
        // }

        if (settingsData['ph'] == true) {
          if (data['ph'] > 14 || data['ph'] <= 0) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    icon: Icon(
                      Icons.error_outline_rounded,
                    ),
                    content: Text(
                      "The are somthing wrong with the PH value ",
                    ),
                    backgroundColor: Color(0xFF212332),
                    shadowColor: Color.fromARGB(255, 143, 8, 8),
                    actions: [
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Close'),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 143, 3, 3),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          }
        }
      }
    });
  }

  List<CloudStorageInfo> fillList() {
    List<CloudStorageInfo> demoMyFiles = [];
    if (data != null) {
      if (settingsData['tempurature'] == true) {
        demoMyFiles.add(
          CloudStorageInfo(
            title: data['temp'].toString() + " C°",
            numOfFiles: "Temperature",
            svgSrc: "assets/icons/therm.svg",
            totalStorage: "Temperature",
            color: primaryColor,
            percentage: 35,
          ),
        );
      }
      if (settingsData['oxygen'] == true) {
        demoMyFiles.add(
          CloudStorageInfo(
            title: data['oxy'].toString() + ' ml',
            numOfFiles: "Oxygène dissous",
            svgSrc: "assets/oxygen-icon.svg",
            totalStorage: "Oxygène dissous",
            color: Color(0xFFA4CDFF),
            percentage: 10,
          ),
        );
      }
      if (settingsData['conductivity'] == true) {
        demoMyFiles.add(
          CloudStorageInfo(
            title: data['cond'].toString() + ' Ω',
            numOfFiles: "Conductivité",
            svgSrc: "assets/icons/bolt.svg",
            totalStorage: "Conductivité",
            color: Color(0xFFFFA113),
            percentage: 35,
          ),
        );
      }
      if (settingsData['ph'] == true) {
        demoMyFiles.add(
          CloudStorageInfo(
            title: data['ph'].toString(),
            numOfFiles: "Niveau de PH",
            svgSrc: "assets/ph.svg",
            totalStorage: "Niveau de PH",
            color: Color(0xFF007EE5),
            percentage: 78,
          ),
        );
      }
    }

    return demoMyFiles;
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: 2,
            childAspectRatio: 0.5,
            demoMyFiles: demoMyFiles,
          ),
          tablet: FileInfoCardGridView(
            demoMyFiles: demoMyFiles,
          ),
          desktop: FileInfoCardGridView(
            childAspectRatio: 2,
            demoMyFiles: demoMyFiles,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.5,
    required this.demoMyFiles,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final List<CloudStorageInfo> demoMyFiles;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoMyFiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => FileInfoCard(info: demoMyFiles[index]),
    );
  }
}
