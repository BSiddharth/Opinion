import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

Future<String> profilePicLinkGen(File? _image, String userToken) async {
  if (_image == null) {
    print("image null");
    return "https://firebasestorage.googleapis.com/v0/b/opinion-46f23.appspot.com/o/ProfilePictures%2Fuser_placeholder.jpg?alt=media&token=775ceaf8-f46c-4ea5-91f8-8fffb8fab1da";
  }
  File returnFile;

  if (_image.lengthSync() <= 200000) {
    print("image len is ${_image.lengthSync()}");
    returnFile = _image;
  } else {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(_image.path);

    returnFile = await FlutterNativeImage.compressImage(
      _image.path,
      quality: 70,
      percentage: 70,
      targetWidth: 1080,
      targetHeight: (properties.height! * 1080 / properties.width!).round(),
    );
  }
  await FirebaseAuth.instance.signInAnonymously();
  try {
    TaskSnapshot task = await FirebaseStorage.instance
        .ref("ProfilePictures/$userToken")
        .putFile(returnFile);
    return await task.ref.getDownloadURL();
  } catch (err) {
    print('error is $err');
    return "https://firebasestorage.googleapis.com/v0/b/opinion-46f23.appspot.com/o/ProfilePictures%2Fuser_placeholder.jpg?alt=media&token=775ceaf8-f46c-4ea5-91f8-8fffb8fab1da";
  }

  // task.then((TaskSnapshot snapshot) async {
  //   print('Upload complete!');
  //   final String downloadUrl = await snapshot.ref.getDownloadURL();
  //   print(downloadUrl);
  //   return downloadUrl;
  // }).catchError((Object e) {
  //   print(e); // FirebaseException
  //   return "https://firebasestorage.googleapis.com/v0/b/opinion-46f23.appspot.com/o/ProfilePictures%2Fuser_placeholder.jpg?alt=media&token=775ceaf8-f46c-4ea5-91f8-8fffb8fab1da";
  // });
}
