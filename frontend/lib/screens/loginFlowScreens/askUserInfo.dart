import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:opinion_frontend/components/askUserInfoPageTextFormField.dart';
import 'package:opinion_frontend/const.dart';
import 'package:opinion_frontend/models/userDetails.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/services/createUser.dart';
import 'package:opinion_frontend/services/generateDeviceToken.dart';
import 'package:opinion_frontend/services/glowRemover.dart';
import 'package:opinion_frontend/services/profilePicLinkGenerator.dart';
import 'package:opinion_frontend/services/startupScreenDecider.dart';
import 'package:opinion_frontend/services/validators.dart';

final imageProviderProvider = StateProvider.autoDispose<ImageProvider>(
    (ref) => AssetImage("assets/images/user_placeholder.jpg"));
final imageFilledProvider = StateProvider<bool>((ref) => false);
final imageFileProvider = StateProvider<File?>((ref) => null);

enum ButtonState { working, idle }
final buttonStateProvider =
    StateProvider.autoDispose<ButtonState>((ref) => ButtonState.idle);

class AskUserInfo extends StatelessWidget {
  static const screenName = '/askUserInfo';
  final String email;
  final String callbacktoken;
  final picker = ImagePicker();
  final _usernameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AskUserInfo({required this.email, required this.callbacktoken});

  Future _getImageThroughCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    // context.read(imageProviderStateProvider).state =
    //     FileImage(File(pickedFile!.path));

    // setState(() {
    //   _image = File(pickedFile!.path);
    // });
    if (pickedFile?.path != null) {
      _cropImage(context, pickedFile!.path);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future _getImageThroughGallery(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    // context.read(imageProviderStateProvider).state =
    //     FileImage(File(pickedFile!.path));

    // setState(() {
    //   _image = File(pickedFile!.path);
    // });
    if (pickedFile?.path != null) {
      _cropImage(context, pickedFile!.path);
    } else {
      Navigator.of(context).pop();
    }
  }

  void getImage(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Profile photo",
                  style: TextStyle(
                    fontSize: 19,
                    // color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt_rounded),
                title: Text(
                  'Camera',
                ),
                onTap: () {
                  _getImageThroughCamera(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.image),
                title: new Text(
                  'Gallery',
                ),
                onTap: () {
                  _getImageThroughGallery(context);
                },
              ),
              context.read(imageFilledProvider).state == true
                  ? ListTile(
                      leading: new Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      title: new Text(
                        'Remove',
                      ),
                      onTap: () {
                        context.read(imageProviderProvider).state =
                            AssetImage("assets/images/user_placeholder.jpg");
                        context.read(imageFileProvider).state = null;
                        context.read(imageFilledProvider).state = false;

                        Navigator.of(context).pop();
                      },
                    )
                  : Container(),
            ],
          );
        });
  }

  Future<Null> _cropImage(BuildContext context, String imageAddress) async {
    File? croppedFile = await ImageCropper.cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: imageAddress,
        // sourcePath: _image!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.original,
              ]
            : [
                CropAspectRatioPreset.original,
              ],
        androidUiSettings: AndroidUiSettings(
            activeControlsWidgetColor: Colors.redAccent,
            toolbarTitle: '',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: '',
        ));
    if (croppedFile?.path != null) {
      context.read(imageProviderProvider).state =
          FileImage(File(croppedFile!.path));
      context.read(imageFileProvider).state = File(croppedFile.path);

      context.read(imageFilledProvider).state = true;
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
    }

    // setState(() {
    //   _image = File(croppedFile.path);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kGgreyishBlack,
          elevation: 0,
          title: Text(
            "Let's get you setup",
            style: TextStyle(
              // fontSize: 37,
              // fontFamily: "Baloo",
              // fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
        body: GlowRemover(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Consumer(builder: (context, watch, child) {
                    ImageProvider imageProvider =
                        watch(imageProviderProvider).state;
                    return GestureDetector(
                      child: Container(
                        width: 250.0,
                        height: 250.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: imageProvider,

                            //   image: (_image == null
                            //     ? AssetImage(
                            //         "assets/user_placeholder.jpg")
                            //     : FileImage(_image!))
                            // as ImageProvider<Object>,
                          ),
                        ),
                      ),
                      onTap: () {
                        getImage(context);
                      },
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Tap to change",
                    style: TextStyle(
                      fontSize: 18,
                      // fontFamily: "Baloo",
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        AskUserInfoPageTextFormField(
                          hintText: "First name",
                          validator: askUserInfoPageFirstNameValidator,
                          controller: _firstnameController,
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        AskUserInfoPageTextFormField(
                          hintText: "Last name (Optional)",
                          validator: askUserInfoPageLastNameValidator,
                          controller: _lastnameController,
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        AskUserInfoPageTextFormField(
                          hintText: "User name",
                          validator: askUserInfoPageUserNameValidator,
                          controller: _usernameController,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                                borderRadius: BorderRadius.circular(50.0),
                                side: BorderSide(color: Colors.black)),
                          ),
                          onPressed: () async {
                            if (context.read(buttonStateProvider).state ==
                                    ButtonState.idle &&
                                _formKey.currentState!.validate()) {
                              context.read(buttonStateProvider).state =
                                  ButtonState.working;

                              String profilePicLink = await profilePicLinkGen(
                                  context.read(imageFileProvider).state,
                                  context.read(tokenProvider).state.toString());
                              print(profilePicLink);
                              final response = await createUser(
                                email: email,
                                callBackToken: callbacktoken,
                                username: _usernameController.text.trim(),
                                firstname: _firstnameController.text.trim(),
                                lastname: _lastnameController.text.trim(),
                                profilePicLink: profilePicLink,
                              );
                              if (response.statusCode == 200) {
                                Map<String, dynamic> data =
                                    json.decode(json.decode(response.body));

                                final userDetails = UserDetails(
                                  firstname: _firstnameController.text.trim(),
                                  username: _usernameController.text.trim(),
                                  lastname: _lastnameController.text.trim(),
                                  userprofileimagelink: profilePicLink,
                                );
                                context.read(currentUserDetailsProvider).state =
                                    userDetails;
                                await Hive.box('userDetails').add(userDetails);

                                context.read(tokenProvider).state =
                                    data['token'];
                                final storage = FlutterSecureStorage();
                                await storage.write(
                                    key: kLoginToken, value: data['token']);
                    generateDeviceToken(data['token']);

                                context
                                    .read(authenticationStatusProvider)
                                    .state = AuthenticationStatus.authenticated;
                                Navigator.popUntil(
                                    context,
                                    ModalRoute.withName(
                                        StartUpScreenDecider.screenName));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Something went wrong!"),
                                ));
                                context.read(buttonStateProvider).state =
                                    ButtonState.idle;
                              }
                            }
                          },
                          child: watch(buttonStateProvider).state ==
                                  ButtonState.idle
                              ? Text(
                                  "CONTINUE",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
