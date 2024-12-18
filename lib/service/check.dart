import 'package:eapp/screen/home_page.dart';
import 'package:eapp/screen/register_page.dart';
import 'package:eapp/service/data_base.dart';
import 'package:flutter/material.dart';

class CheckSignInPage extends StatelessWidget {
  // Check if user is signed in using sqflite
  Future<bool> checkIfUserSignedIn() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    return await dbHelper.isUserSignedIn(); // Returns true if signed in
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkIfUserSignedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is signed in, navigate to HomePage; otherwise, navigate to SignInPage
        if (snapshot.data == true) {
          return HomePage(); // Replace with your actual HomePage widget
        } else {
          return RegisterScreen(); // Replace with your actual SignInPage widget
        }
      },
    );
  }
}
