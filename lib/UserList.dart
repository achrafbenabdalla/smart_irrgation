 import 'package:flutter/material.dart';
import 'package:flutter_tes/formsUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserList extends StatelessWidget {
  void _onButtonPressed(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => formsUser()),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of USER"),
        backgroundColor: Color(0xff259e73),
      ),
      body: Stack(
        children: [
          Center(
            child: DataTableExample(),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                _onButtonPressed(context); // Navigate to the second page
                // Add button functionality here
              },
              child: Text('ADD New USER'),
            ),
          ),
        ],
      ),
    );
  }
}

 class DataTableExample extends StatelessWidget {
    DataTableExample({Key? key}) : super(key: key);

   // Step 1: Define custom highlight color
   Color _highlightColor = Colors.red.withOpacity(0.5);

   @override
   Widget build(BuildContext context) {
     return StreamBuilder<QuerySnapshot>(
       stream: readDataFromFirestore(),
       builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
           return CircularProgressIndicator();
         } else if (snapshot.hasError) {
           return Text('Failed to read data: ${snapshot.error}');
         } else if (snapshot.hasData) {
           // List of field names for the columns in the DataTable
           List<String> fieldNames = [
             'Name',
             'LastName',
             'CIN',
             'Password',
             'ConfirmPass',
             'actions',
             'isValid'
           ];

           List<DataRow> rows = [];
           snapshot.data!.docs.forEach((document) {
             var data = document.data() as Map<String, dynamic>;

             List<DataCell> cells = [];
             fieldNames.forEach((fieldName) {
               if (fieldName == 'actions') {
                 // Add both the d
                 //
                 cells.add(DataCell(Row(
                   children: [
                     Checkbox(
                       value: data['isValid'] ?? false,
                       onChanged: (newValue) async {
                         if (newValue != null) {
                           if (newValue) {
                             // Update the isValid field in the Firestore document
                             await FirebaseFirestore.instance
                                 .collection('userAdmin')
                                 .doc(document.id)
                                 .update({
                               'isValid': true,
                             });

                             // Show a dialog to notify the admin that the user has been validated
                             showDialog(
                               context: context,
                               builder: (BuildContext context) {
                                 return AlertDialog(
                                   title: Text('User Validated'),
                                   content: Text('The user (${data['Name']} ${data['LastName']}) has been validated.'),
                                   actions: [
                                     TextButton(
                                       onPressed: () {
                                         Navigator.pop(context); // Close the dialog
                                       },
                                       child: Text('OK'),
                                     ),
                                   ],
                                 );
                               },
                             );
                           } else {
                             // If the checkbox is unchecked, you can add additional logic here if needed.
                           }
                         }
                       },
                     ),
                     IconButton(
                       icon: Icon(Icons.edit),
                       onPressed: () {
                         _editUser(context,
                             document); // Call the _editUser method when "Edit" is pressed
                       },
                     ),
                     IconButton(
                       icon: Icon(Icons.delete),
                       onPressed: () {
                         // Show a confirmation dialog before deleting the user
                         showDialog(
                           context: context,
                           builder: (BuildContext context) {
                             return AlertDialog(
                               title: Text('Confirm Delete'),
                               content: Text(
                                   'Are you sure you want to delete this user (${data['Name']} ${data['LastName']})?'),
                               actions: [
                                 TextButton(
                                   onPressed: () {
                                     Navigator.pop(
                                         context); // Close the confirmation dialog
                                   },
                                   child: Text('Cancel'),
                                 ),
                                 TextButton(
                                   onPressed: () async {
                                     // Delete the user and close the confirmation dialog
                                     await FirebaseFirestore.instance
                                         .collection('userAdmin')
                                         .doc(document.id)
                                         .delete();
                                     Navigator.pop(
                                         context); // Close the confirmation dialog
                                     // Show another AlertDialog to display the username that was deleted
                                     showDialog(
                                       context: context,
                                       builder: (BuildContext context) {
                                         return AlertDialog(
                                           title: Text('User Deleted'),
                                           content: Text(
                                               'The user (${data['Name']} ${data['LastName']}) has been deleted.'),
                                           actions: [
                                             TextButton(
                                               onPressed: () {
                                                 Navigator.pop(
                                                     context); // Close the username deleted dialog
                                               },
                                               child: Text('OK'),
                                             ),
                                           ],
                                         );
                                       },
                                     );
                                   },
                                   child: Text('Delete'),
                                 ),
                               ],
                             );
                           },
                         );
                       },
                     ),
                   ],
                 )));
               } else {
                 cells.add(DataCell(Text(data[fieldName]?.toString() ?? '')));
               }
             });

             // Step 2: Create a MaterialStateColor for the row color
             MaterialStateColor rowColor = MaterialStateColor.resolveWith((states) {
               if (data['isValid'] == false) {
                 return _highlightColor;
               }
               return Colors.transparent; // Transparent color for other states
             });
             rows.add(
               DataRow(
                 cells: cells,
                 color: MaterialStateProperty.resolveWith((states) {
                   return rowColor;
                 }),
               ),
             );
           });

           List<DataColumn> columns = fieldNames.map((fieldName) {
             return DataColumn(
               label: Expanded(
                 child: Text(
                   fieldName,
                   style: TextStyle(fontStyle: FontStyle.italic),
                 ),
               ),
             );
           }).toList();
           // Add a new DataColumn for the "Status" field
           return SingleChildScrollView(
             scrollDirection: Axis.vertical,
             child: DataTable(
               columns: columns,
               rows: rows,
             ),
           );
         } else {
           return Text('No documents found');
         }
       },
     );
   }
   Stream<QuerySnapshot> readDataFromFirestore() {
     FirebaseFirestore firestore = FirebaseFirestore.instance;
     // Replace "your_collection" with the name of your collection
     return firestore.collection('userAdmin').snapshots();
   }

   void _editUser(BuildContext context, DocumentSnapshot document) async {
     // Create a TextEditingController for each field to allow editing user data
     TextEditingController nameController = TextEditingController(
         text: document['Name']);
     TextEditingController lastNameController = TextEditingController(
         text: document['LastName']);
     TextEditingController CINController = TextEditingController(
         text: document['CIN'].toString());
     TextEditingController PasswordController = TextEditingController(
         text: document['Password']);
     TextEditingController ConfirmPassController = TextEditingController(
         text: document['ConfirmPass']);

     // ... Add other TextEditingController for each field ...

     final result = await showDialog(
       context: context,
       builder: (BuildContext context) {
         // Return the AlertDialog widget that will be shown as a popup
         return AlertDialog(
           title: Text('Edit User'),
           content: SingleChildScrollView(
             child: Column(
               children: [
                 // Add form fields here to allow editing user data
                 TextField(
                   controller: nameController,
                   decoration: InputDecoration(labelText: 'Name'),
                 ),
                 TextField(
                   controller: lastNameController,
                   decoration: InputDecoration(labelText: 'Last Name'),
                 ),


                 TextField(
                   controller: CINController,
                   decoration: InputDecoration(labelText: 'CIN'),
                 ),


                 // ... Add other TextFields for other user data fields (CIN, Password, etc.) ...
               ],
             ),
           ),
           actions: [
             TextButton(
               onPressed: () {
                 Navigator.pop(
                     context, 'cancel'); // Close the popup with a cancel result
               },
               child: Text('Cancel'),
             ),
             TextButton(
               onPressed: () async {
                 // Perform the update operation here, using the document reference and updated data
                 String updatedName = nameController.text;
                 String updatedLastName = lastNameController.text;
                 int updatedCIN = int.parse(CINController.text);
                // String updatedPassword = PasswordController.text;
                 //String updatedConfirmPass = ConfirmPassController.text;


                 // ... Get updated values from other TextFields ...

                 // Example of how to update Firestore document
                 await document.reference.update({
                   'Name': updatedName,
                   'LastName': updatedLastName,
                   'CIN': updatedCIN,
             //      'Password': updatedPassword,
                //   'ConfirmPass': updatedConfirmPass
                   // ... Update other fields as needed ...
                 });

                 Navigator.pop(context,
                     'update'); // Close the popup with an update result
                 showDialog(
                   context: context,
                   builder: (BuildContext context) {
                     return AlertDialog(
                       title: Text('User Updated'),
                       content: Text('The user (${updatedName} ${updatedLastName}) has been updated.'),
                       actions: [
                         TextButton(
                           onPressed: () {
                             Navigator.pop(context); // Close the confirmation dialog
                           },
                           child: Text('OK'),
                         ),
                       ],
                     );
                   },
                 );
               },

               child: Text('Update'),
             ),
           ],
         );
       },
     );

     // Handle the result returned from the popup (result can be 'cancel' or 'update')
     if (result == 'update') {
       // Refresh the data after an update (if necessary)
       // Note: You may want to use a Stateful widget for UserList and manage the StreamBuilder there
       // to trigger an update when data is modified.
     }

     Stream<QuerySnapshot> readDataFromFirestore() {
       FirebaseFirestore firestore = FirebaseFirestore.instance;
       // Replace "your_collection" with the name of your collection
       return firestore.collection('userAdmin').snapshots();
     }
   }

 }
