import 'dart:async';
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashtoast/flash_toast.dart';

class MyFilesss extends StatefulWidget {
  MyFilesss({Key? key}) : super(key: key);

  @override
  _MyFilesssState createState() => _MyFilesssState();
}

class _MyFilesssState extends State<MyFilesss> {
  late StreamSubscription<DocumentSnapshot> sensorDataSubscription;
  dynamic sensorData;
  dynamic data;
  String tempData = "";
  Map<String, dynamic> settingsData = {};
  List<CloudStorageInfo> demoMyFiles = [];

  @override
  void initState() {
    super.initState();
    fetchSettingsData();
    listenToSensorData();
  }

  @override
  void dispose() {
    sensorDataSubscription.cancel(); // Cancel the real-time listener
    super.dispose();
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
      print(settingsData['data']);
    }
  }

  void listenToSensorData() {
    User? user = FirebaseAuth.instance.currentUser;
    var userID = user!.uid;

    sensorDataSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .snapshots()
        .listen((docSnapshot) {
      if (docSnapshot.exists) {
        final userData = docSnapshot.data();
        setState(() {
          sensorData = userData?['data'];
        });

        // Check for conditions and display alerts if needed
        if (sensorData != null) {
          final temperature = sensorData?['temp'];
          final pH = sensorData?['pH'];
          final conductivity = sensorData?['conductivity'];
          final oxy = sensorData?['oxy'];

          // Update the UI with the new sensor data
          setState(() {
            this.sensorData = sensorData;
            demoMyFiles = fillList();
          });

          // Check for conditions and display alerts if needed
          if (settingsData['tempurature'] == true && temperature > 50) {
            FlashToast.showFlashToast(
                context: context,
                title: "worning ",
                message: "tempurature is too hight !!",
                flashType: FlashType.error,
                duration: 2, //seconds
                width:
                    400, //by default its full screen width with 10px form left right padding
                height: 100, //by default its 100px
                flashPosition:
                    FlashPosition.top, //by defaults its FlashPosition.top
                opacity: 0.8, //by default its 1.0
                padding: EdgeInsets.all(20));
          }
          if (settingsData['oxy'] == true && 1 > oxy || oxy > 10) {
            FlashToast.showFlashToast(
                context: context,
                title: "worning ",
                message: "the values of oxygéne seems wrong  !!",
                flashType: FlashType.error,
                duration: 6, //seconds
                width:
                    400, //by default its full screen width with 10px form left right padding
                height: 100, //by default its 100px
                flashPosition:
                    FlashPosition.center, //by defaults its FlashPosition.top
                opacity: 0.8, //by default its 1.0
                padding: EdgeInsets.all(20));
          }
          if (settingsData['pH'] == true && 0 < pH || pH > 14) {
            FlashToast.showFlashToast(
                context: context,
                title: "worning ",
                message: "the values of PH seems wrong  !!",
                flashType: FlashType.error,
                duration: 3, //seconds
                width:
                    400, //by default its full screen width with 10px form left right padding
                height: 100, //by default its 100px
                flashPosition:
                    FlashPosition.bottom, //by defaults its FlashPosition.top
                opacity: 0.8, //by default its 1.0
                padding: EdgeInsets.all(20));
          }
          if (settingsData['conductivity'] == true && 1 < conductivity ||
              conductivity < 10) {
            FlashToast.showFlashToast(
                context: context,
                title: "worning ",
                message: "the values of conductivity seems wrong  !!",
                flashType: FlashType.error,
                duration: 3, //seconds
                width:
                    400, //by default its full screen width with 10px form left right padding
                height: 100, //by default its 100px
                flashPosition:
                    FlashPosition.center, //by defaults its FlashPosition.top
                opacity: 0.8, //by default its 1.0
                padding: EdgeInsets.all(20));
          }

          // Add similar conditions and alerts for other sensor data (pH, conductivity, etc.)
        }
      }
    });
  }

  List<CloudStorageInfo> fillList() {
    List<CloudStorageInfo> demoMyFiles = [];
    if (sensorData != null) {
      final temperature = sensorData['temp'];
      final pH = sensorData['pH'];
      final conductivity = sensorData['conductivity'];
      final oxy = sensorData['oxy'];
      if (settingsData['tempurature'] == true) {
        demoMyFiles.add(
          CloudStorageInfo(
            title: temperature.toStringAsFixed(2) + " C°",
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
            title: oxy.toStringAsFixed(2) + ' ml',
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
            title: conductivity.toStringAsFixed(2) + ' Ω',
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
            title: pH.toStringAsFixed(2),
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
            crossAxisCount: 1,
            childAspectRatio: 1.5,
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
