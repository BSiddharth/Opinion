import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:opinion_frontend/components/loginButton.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/screens/loginFlowScreens/otpVerficationScreen.dart';
import 'package:opinion_frontend/services/getCallBackToken.dart';
import 'package:opinion_frontend/services/glowRemover.dart';
import 'package:opinion_frontend/services/loginWithGoogle.dart';
import 'package:opinion_frontend/services/validators.dart';
import 'package:opinion_frontend/const.dart';

enum ButtonState { sendingEmail, idle }
final buttonStateProvider =
    StateProvider.autoDispose<ButtonState>((ref) => ButtonState.idle);

class LoginScreen extends StatelessWidget {
  static const screenName = "/loginScreen";
  final _formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlowRemover(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Container(
              color: kGgreyishBlack,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "OPINION",
                    style: TextStyle(
                      fontFamily: "Amatic",
                      fontSize: 100,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                focusNode: _emailFocus,
                                controller: emailTextController,
                                cursorColor: Colors.redAccent,
                                keyboardType: TextInputType.emailAddress,
                                autofocus: false,
                                validator: (value) {
                                  return loginPageEmailValidator(value);
                                },
                                onSaved: (value) {
                                  context.read(emailProvider).state = value!;
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    color: Colors.grey,
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Consumer(builder: (context, watch, child) {
                          final emailState = watch(buttonStateProvider);
                          return SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              onPressed: () async {
                                if (context.read(buttonStateProvider).state ==
                                    ButtonState.sendingEmail) {
                                  return;
                                }
                                if (_formKey.currentState!.validate()) {
                                  _emailFocus.unfocus();
                                  _formKey.currentState!.save();
                                  context.read(buttonStateProvider).state =
                                      ButtonState.sendingEmail;
                                  final response = await getCallBackToken(
                                      emailTextController.text.trim());

                                  if (response.statusCode == 200) {
                                    Navigator.pushNamed(context,
                                        OtpVerificationScreen.screenName,
                                        arguments: {
                                          "email":
                                              emailTextController.text.trim()
                                        });
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Something went wrong!"),
                                    ));
                                  }
                                  context.read(buttonStateProvider).state =
                                      ButtonState.idle;
                                }
                              },
                              child: emailState.state == ButtonState.idle
                                  ? Text(
                                      "SEND VERIFICATION OTP",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 1.0,
                                      ),
                                    )
                                  : LoadingIndicator(
                                      indicatorType: Indicator.ballPulse,
                                      color: Colors.white,
                                    ),
                            ),
                          );
                        }),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Colors.white,
                                indent: 30,
                                endIndent: 10,
                              ),
                            ),
                            Text(
                              "OR",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white,
                                indent: 10,
                                endIndent: 30,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        LoginButton(
                          imageString: "assets/images/google_logo.png",
                          textString: "CONTINUE WITH GOOGLE",
                          function: loginWithGoogle,
                        ),
                        LoginButton(
                          imageString: "assets/images/facebook_logo.png",
                          textString: "CONTINUE WITH FACEBOOK",
                          function: () {},
                        ),
                        LoginButton(
                          imageString: "assets/images/twitter_logo.png",
                          textString: "CONTINUE WITH TWITTER",
                          function: () {},
                        ),
                        LoginButton(
                          imageString: "assets/images/apple_logo.png",
                          textString: "CONTINUE WITH APPLE",
                          function: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
