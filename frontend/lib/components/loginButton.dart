import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:opinion_frontend/const.dart';
import 'package:opinion_frontend/models/userDetails.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/screens/loginFlowScreens/askUserInfo.dart';
import 'package:opinion_frontend/services/generateDeviceToken.dart';
import 'package:opinion_frontend/services/startupScreenDecider.dart';

class LoginButton extends StatelessWidget {
  LoginButton(
      {required this.imageString,
      required this.textString,
      required this.function});
  final String imageString;
  final String textString;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  side: BorderSide(
                    // color: Colors.black,
                    color: Colors.white,
                  )),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imageString),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  textString,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.0,
                    // ldflf
                    // color: Colors.white,
                  ),
                ),
              ],
            ),
            onPressed: () async {
              final response = await function();
              Map<String, dynamic> data =
                  json.decode(json.decode(response.body));

              if (data["NewUser"] == 'true') {
                Navigator.pushNamed(context, AskUserInfo.screenName,
                    arguments: {
                      'email': data["email"],
                      'callbacktoken': data["callbacktoken"]
                    });
              } else {
                context.read(tokenProvider).state = data["token"];
                generateDeviceToken(data['token']);
                final userDetails = UserDetails(
                  firstname: data['firstname'],
                  username: data['username'],
                  lastname: data['lastname'],
                  userprofileimagelink: data['profilepiclink'],
                  title: data['description'],
                  about: data['about'],
                );
                context.read(currentUserDetailsProvider).state = userDetails;
                Hive.box('userDetails').add(userDetails);
                final storage = FlutterSecureStorage();
                await storage.write(key: kLoginToken, value: data['token']);
                context.read(authenticationStatusProvider).state =
                    AuthenticationStatus.authenticated;

                Navigator.popUntil(context,
                    ModalRoute.withName(StartUpScreenDecider.screenName));
              }
            },
          ),
        ),
      );
    });
  }
}
 