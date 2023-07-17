import 'package:flutter_tes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tes/models/MyFiles.dart';
import '../../../constants.dart';
import 'file_info_card.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Files",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {},
              icon: Icon(Icons.add),
              label: Text("Add New"),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: 2,
            childAspectRatio: 1.3,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  List demoMyFiles = [
    CloudStorageInfo(
      title: "27 C°",
      numOfFiles: "Temperature",
      svgSrc: "assets/icons/therm.svg",
      totalStorage: "Temperature",
      color: primaryColor,
      percentage: 35,
    ),
    CloudStorageInfo(
      title: "100 Ω",
      numOfFiles: "Conductivité",
      svgSrc: "assets/icons/bolt.svg",
      totalStorage: "Conductivité",
      color: Color(0xFFFFA113),
      percentage: 35,
    ),
    CloudStorageInfo(
      title: "25 ml",
      numOfFiles: "Oxygène dissous",
      svgSrc: "assets/oxygen-icon.svg",
      totalStorage: "Oxygène dissous",
      color: Color(0xFFA4CDFF),
      percentage: 10,
    ),
    CloudStorageInfo(
      title: "7 PH",
      numOfFiles: "Niveau de PH",
      svgSrc: "assets/ph.svg",
      totalStorage: "Niveau de PH",
      color: Color(0xFF007EE5),
      percentage: 78,
    ),
  ];
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
