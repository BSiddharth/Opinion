import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:opinion_frontend/components/editUserDetailsTextFormField.dart';
import 'package:opinion_frontend/components/showProfilePicture.dart';
import 'package:opinion_frontend/models/userDetails.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/services/glowRemover.dart';
import 'package:opinion_frontend/services/updateUserDetails.dart';

class EditProfileScreen extends StatefulWidget {
  static const screenName = '/editProfileScreen';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    userDetails = context.read(currentUserDetailsProvider).state;
    _titleController = TextEditingController(
      text: userDetails.title,
    );
    _usernameController = TextEditingController(
      text: userDetails.username,
    );
    _lastnameController = TextEditingController(
      text: userDetails.lastname,
    );
    _firstnameController = TextEditingController(
      text: userDetails.firstname,
    );
    _aboutController = TextEditingController(
      text: userDetails.about,
    );
    super.initState();
  }

  late UserDetails userDetails;
  late TextEditingController _titleController;
  late TextEditingController _usernameController;
  late TextEditingController _lastnameController;
  late TextEditingController _firstnameController;
  late TextEditingController _aboutController;
  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Edit Profile'),
          titleSpacing: 0.0,
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                final UserDetails newUserDetails =
                    context.read(currentUserDetailsProvider).state.copyWith(
                          username: _usernameController.text,
                          lastname: _lastnameController.text,
                          firstname: _firstnameController.text,
                          about: _aboutController.text,
                          title: _titleController.text,
                        );
                context.read(currentUserDetailsProvider).state = newUserDetails;
                updateUserDetails(
                    token: context.read(tokenProvider).state!,
                    userDetails: newUserDetails);
                await Hive.box('userDetails').putAt(0, newUserDetails);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: GlowRemover(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ShowProfilePicture(
                      url: userDetails.userprofileimagelink, dimension: 200),
                ),
                Center(
                  child: Text(
                    'Tap to change',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                    child: Column(
                  children: [
                    EditUserDetailsTextFormField(
                      labelText: 'Username',
                      validator: () {},
                      controller: _usernameController,
                      maxLength: 20,
                    ),
                    EditUserDetailsTextFormField(
                      labelText: 'Firstname',
                      validator: () {},
                      controller: _firstnameController,
                      maxLength: 20,
                    ),
                    EditUserDetailsTextFormField(
                      labelText: 'Lastname',
                      validator: () {},
                      controller: _lastnameController,
                      maxLength: 20,
                    ),
                    EditUserDetailsTextFormField(
                      labelText: 'Title',
                      validator: () {},
                      controller: _titleController,
                      maxLength: 20,
                    ),
                    EditUserDetailsTextFormField(
                      minlines: 4,
                      maxLines: 5,
                      labelText: 'About',
                      validator: () {},
                      controller: _aboutController,
                      maxLength: 150,
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
