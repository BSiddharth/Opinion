import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opinion_frontend/screens/appIconScreen.dart';
import 'package:opinion_frontend/screens/loginFlowScreens/loginScreen.dart';
import 'package:opinion_frontend/screens/mainAppScreens/mainAppScreen.dart';
import 'package:opinion_frontend/providers.dart';

class StartUpScreenDecider extends ConsumerWidget {
  static const screenName = "/";
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final authstatus = watch(authenticationStatusProvider).state;
    switch (authstatus) {
      case AuthenticationStatus.authenticated:
        {
          return MainAppScreen();
        }

      case AuthenticationStatus.notAuthenticated:
        {
          return LoginScreen();
        }

      case AuthenticationStatus.loading:
        {
          return AppIconScreen();
        }

      default:
        {
          return Scaffold(
            body: Container(
              child: Center(
                child: Text(
                  "Oopsie Something went wrong!!!",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              color: Colors.redAccent,
            ),
          );
        }
    }
  }
}
