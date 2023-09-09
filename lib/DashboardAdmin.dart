import 'package:flutter/material.dart';
import 'package:flutter_tes/ConfigurationList.dart';
import 'package:flutter_tes/ListOfDemandeSensorsPage.dart';
import 'package:flutter_tes/UserList.dart';
import 'package:flutter_tes/authAdmin.dart';
import 'package:flutter_tes/sign-in-admin.dart';


class DashboardPageAdmin extends StatelessWidget {
  DashboardPageAdmin(AuthAdmin authAdmin);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Color(0xff259e73),
        actions: [
          // Add a logout button to the top-right corner of the AppBar
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInAdmin()),
              );              // Implement your logout logic here
              // You can navigate to the login screen or perform any other logout actions
            },
          ),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableBox(
              title: 'Users',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserList(),
                  ),
                );
              },
              onDoubleTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserList(),
                  ),
                );
              },
            ),
            SizedBox(width: 20),
            SelectableBox(
              title: 'Configuration',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListOfDemandeSensorsPage(
                      isAdmin: true, // Assuming you are the admin
                    ),
                  ),
                );
              },
              onDoubleTap: () {},
            ),
            SizedBox(width: 20),

          ],
        ),
      ),
    );
  }
}
mixin authAdmin {
}

class SelectableBox extends StatefulWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  SelectableBox({
    required this.title,
    required this.color,
    required this.onTap,
    required this.onDoubleTap,
  });

  @override
  _SelectableBoxState createState() => _SelectableBoxState();
}

class _SelectableBoxState extends State<SelectableBox> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });

        widget.onTap();
      },
      onDoubleTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });

        widget.onDoubleTap();
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: _isSelected ? widget.color.withOpacity(0.8) : widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              color: _isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

}
