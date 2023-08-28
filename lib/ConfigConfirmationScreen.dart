import 'package:flutter/material.dart';

class UserDataTablePage extends StatelessWidget {
  final String name;
  final String lastName;
  final String cin;
  final bool temp;
  final bool cond;
  final bool oxy;
  final bool ph;

  UserDataTablePage({
    required this.name,
    required this.lastName,
    required this.cin,
    required this.temp,
    required this.cond,
    required this.oxy,
    required this.ph,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data Table'),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Field')),
            DataColumn(label: Text('Value')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('Name')),
              DataCell(Text(name)),
            ]),
            DataRow(cells: [
              DataCell(Text('Last Name')),
              DataCell(Text(lastName)),
            ]),
            DataRow(cells: [
              DataCell(Text('CIN')),
              DataCell(Text(cin)),
            ]),
            DataRow(cells: [
              DataCell(Text('Temperature')),
              DataCell(Text(temp.toString())),
            ]),
            DataRow(cells: [
              DataCell(Text('Conductivité')),
              DataCell(Text(cond.toString())),
            ]),
            DataRow(cells: [
              DataCell(Text('Oxygène dissous')),
              DataCell(Text(oxy.toString())),
            ]),
            DataRow(cells: [
              DataCell(Text('Niveau de PH')),
              DataCell(Text(ph.toString())),
            ]),
          ],
        ),
      ),
    );
  }
}
