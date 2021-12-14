import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:uuid/uuid.dart';

Future<String?> postPicLinkGen(File _image) async {
  File returnFile;
  var uuid = Uuid();

  if (_image.lengthSync() <= 400000) {
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
  final randomImageName = uuid.v4();
  print(randomImageName);
  try {
    TaskSnapshot task = await FirebaseStorage.instance
        .ref("PostPictures/$randomImageName")
        .putFile(returnFile);
    return await task.ref.getDownloadURL();
  } catch (err) {
    print('error is $err');
    return null;
  }
}
