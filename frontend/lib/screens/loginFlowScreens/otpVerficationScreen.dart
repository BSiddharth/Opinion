import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:opinion_frontend/const.dart';
import 'package:opinion_frontend/models/userDetails.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/screens/loginFlowScreens/askUserInfo.dart';
import 'package:opinion_frontend/services/generateDeviceToken.dart';
import 'package:opinion_frontend/services/getCallBackToken.dart';
import 'package:opinion_frontend/services/glowRemover.dart';
import 'package:opinion_frontend/services/sendCallBackToken.dart';
import 'package:opinion_frontend/services/startupScreenDecider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

enum ButtonState { working, idle }
final buttonStateProvider =
    StateProvider.autoDispose<ButtonState>((ref) => ButtonState.idle);
final errorTextProvider = StateProvider.autoDispose<String>((ref) => "");

class OtpVerificationScreen extends StatelessWidget {
  static const screenName = '/otpVerificationScreen';
  final callbacktokenTextController = TextEditingController();
  final errorController = StreamController<ErrorAnimationType>();

  final String email;

  OtpVerificationScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kGgreyishBlack,
        appBar: AppBar(
          backgroundColor: kGgreyishBlack,
          elevation: 0,
          title: Text(
            "Email OTP Verification",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: GlowRemover(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 0,
              ),
              color: kGgreyishBlack,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Lottie.asset('assets/illustrations/emailSent.json'),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 8),
                    child: RichText(
                      text: TextSpan(
                          text: "Enter the OTP sent to ",
                          children: [
                            TextSpan(
                                text: email,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ],
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  PinCodeTextField(
                    errorTextSpace: 0,
                    appContext: context,
                    length: 6,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    enablePinAutofill: false,
                    animationType: AnimationType.fade,
                    // controller: callbacktokenTextController,
                    errorAnimationController: errorController,
                    validator: (value) {},
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        activeColor: Colors.redAccent,
                        selectedColor: Colors.redAccent,
                        inactiveColor: Colors.redAccent,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white),
                    animationDuration: Duration(milliseconds: 0),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    onCompleted: (v) {
                      // save value here
                    },
                    onChanged: (value) {
                      callbacktokenTextController.text = value;
                    },
                    beforeTextPaste: (text) {
                      return false;
                    },
                  ),
                  Row(
                    children: [
                      Consumer(builder: (context, watch, child) {
                        String error = watch(errorTextProvider).state;

                        return Text(
                          error,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        );
                      })
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive the code? ",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          getCallBackToken(email);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Sending OTP to $email"),
                          ));
                        },
                        child: Text("RESEND",
                            style: TextStyle(
                                color: Color(0xFF91D3B3),
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: Consumer(
                      builder: (context, watch, child) {
                        return TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: () async {
                            if (context.read(buttonStateProvider).state ==
                                ButtonState.working) {
                              return;
                            }
                            if (callbacktokenTextController.text.length < 6) {
                              errorController.add(ErrorAnimationType.shake);
                              context.read(errorTextProvider).state =
                                  "*6 digit code needed";
                            } else {
                              context.read(errorTextProvider).state = "";
                              context.read(buttonStateProvider).state =
                                  ButtonState.working;
                              final response = await sendCallBackToken(
                                  email, callbacktokenTextController.text);

                              if (response.statusCode == 200) {
                                context.read(buttonStateProvider).state =
                                    ButtonState.idle;

                                Map<String, dynamic> data =
                                    json.decode(json.decode(response.body));

                                if (data["NewUser"] == 'true') {
                                  Navigator.pushNamed(
                                      context, AskUserInfo.screenName,
                                      arguments: {
                                        'email': email,
                                        'callbacktoken':
                                            callbacktokenTextController.text
                                      });
                                } else {
                                  context.read(tokenProvider).state =
                                      data["token"];
                                  generateDeviceToken(data['token']);
                                  final userDetails = UserDetails(
                                    firstname: data['firstname'],
                                    username: data['username'],
                                    lastname: data['lastname'],
                                    userprofileimagelink:
                                        data['profilepiclink'],
                                    title: data['description'],
                                    about: data['about'],
                                  );
                                  context
                                      .read(currentUserDetailsProvider)
                                      .state = userDetails;
                                  Hive.box('userDetails').add(userDetails);
                                  final storage = FlutterSecureStorage();
                                  await storage.write(
                                      key: kLoginToken, value: data['token']);
                                  context
                                          .read(authenticationStatusProvider)
                                          .state =
                                      AuthenticationStatus.authenticated;

                                  Navigator.popUntil(
                                      context,
                                      ModalRoute.withName(
                                          StartUpScreenDecider.screenName));
                                }
                              } else {
                                context.read(buttonStateProvider).state =
                                    ButtonState.idle;
                                context.read(errorTextProvider).state =
                                    "Incorrect Otp";
                                errorController.add(ErrorAnimationType.shake);
                              }
                            }
                          },
                          child: watch(buttonStateProvider).state ==
                                  ButtonState.idle
                              ? Text(
                                  "VERIFY",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 1.0,
                                      fontSize: 18),
                                )
                              : LoadingIndicator(
                                  indicatorType: Indicator.ballPulse,
                                  color: Colors.white,
                                ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
