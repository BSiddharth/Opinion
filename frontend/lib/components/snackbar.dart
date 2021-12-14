import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void snackBarTemplate(
    {required BuildContext context, required String message}) {
  final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1000),
      behavior: SnackBarBehavior.floating,
      elevation: 10.0,
      backgroundColor: Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        // side: BorderSide(
        //   color: Colors.redAccent,
        //   width: 2,
        // ),
      ));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
