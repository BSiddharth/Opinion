import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:opinion_frontend/components/customAlertDialog.dart';
import 'package:opinion_frontend/const.dart';
import 'package:opinion_frontend/models/userDetails.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

logOut(BuildContext context) {
  var dialog = CustomAlertDialog(
      title: "Logout",
      message: "Are you sure you want to logout?",
      onPostivePressed: () async {
        Navigator.pop(context);
        context.read(authenticationStatusProvider).state =
            AuthenticationStatus.notAuthenticated;
        context.read(tokenProvider).state = null;
        context.read(currentUserDetailsProvider).state = UserDetails();
        final storage = FlutterSecureStorage();
        await storage.delete(key: kLoginToken);
        Hive.box('settings').clear();
        Hive.box('userDetails').clear();
      },
      positiveBtnText: 'Yes',
      negativeBtnText: 'No');
  // returning so that can use await in settings page otherwise it moves to next line
  return showDialog(
      context: context, builder: (BuildContext context) => dialog);
}
