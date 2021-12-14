import 'package:flutter/material.dart';

class AppIconScreen extends StatelessWidget {
  const AppIconScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "OPINION",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Amatic",
            fontSize: 100,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
