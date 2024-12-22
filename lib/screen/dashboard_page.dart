import 'package:eapp/screen/all_user.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 200,
        ),
        InkWell(
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AllUsersPage(),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.all(10),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Show all users",
                  style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink),
                ),
                Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 50,
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
