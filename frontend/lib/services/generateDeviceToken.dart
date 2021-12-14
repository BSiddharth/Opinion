import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:opinion_frontend/services/saveDeviceTokenToDatabase.dart';

void generateDeviceToken(String token) async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    saveDeviceTokenToDatabase(deviceToken!,token);
    FirebaseMessaging.instance.onTokenRefresh.listen((String s)=>{saveDeviceTokenToDatabase(s,token)});

    // String? deviceToken = await FirebaseMessaging.instance.getToken();
    // print(deviceToken);
    // String? token = context.read(tokenProvider).state;
    // saveDeviceTokenToDatabase(deviceToken!,token!);
    // FirebaseMessaging.instance.onTokenRefresh.listen((String s)=>{saveDeviceTokenToDatabase(s,token)});
}