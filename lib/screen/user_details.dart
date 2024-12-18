import 'package:eapp/service/data_base.dart';
import 'package:flutter/material.dart'; // You will create this page later to show the shipping orders

class UserPage extends StatefulWidget {
  final int userId; // User ID passed after successful sign-in

  UserPage({required this.userId});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  Map<String, dynamic>? _userDetails;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  // Fetch user details from the database using the user ID
  Future<void> _fetchUserDetails() async {
    var user = await _databaseHelper.queryById(
        DatabaseHelper.tableCustomers, widget.userId);
    setState(() {
      _userDetails = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "User Details",
        style: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.pink),
      )),
      body: _userDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Text(
                    "Name:${_userDetails!['name']}",
                    style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink),
                  ),
                  Text(
                    "Email:${_userDetails!['email']}",
                    style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink),
                  ),
                  Text(
                    "Phone:${_userDetails!['phone']}",
                    style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink),
                  ),
                  Text(
                    "Address:${_userDetails!['address']}",
                    style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink),
                  )
                ],
              ),
            ),
    );
  }
}
