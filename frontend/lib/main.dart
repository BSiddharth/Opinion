import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:opinion_frontend/models/settings.dart';
import 'package:opinion_frontend/models/userDetails.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/screens/commentDetailedPage.dart';
import 'package:opinion_frontend/screens/editProfileScreen.dart';
import 'package:opinion_frontend/screens/loginFlowScreens/askUserInfo.dart';
import 'package:opinion_frontend/screens/loginFlowScreens/otpVerficationScreen.dart';
import 'package:opinion_frontend/screens/sectionPage.dart';
import 'package:opinion_frontend/screens/settingsPage.dart';
import 'package:opinion_frontend/screens/showUserProfile.dart';
import 'package:opinion_frontend/screens/postDetailedPage.dart';
import 'package:opinion_frontend/services/generateDeviceToken.dart';
import 'package:opinion_frontend/services/startupScreenDecider.dart';
import 'const.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(SettingsAdapter());
  Hive.registerAdapter(UserDetailsAdapter());
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));
    preInit(context);
    // generateDeviceToken(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // appBarTheme: AppBarTheme(
        //   brightness: Brightness.light,
        // ),
        primaryColor: Colors.black,
        unselectedWidgetColor: Colors.grey,
        canvasColor: Colors.black,
        scaffoldBackgroundColor: kGgreyishBlack,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.redAccent,
        ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.redAccent),
      ),
      initialRoute: StartUpScreenDecider.screenName,
      routes: {
        StartUpScreenDecider.screenName: (context) => StartUpScreenDecider(),
        SettingsPage.screenName: (context) => SettingsPage(),
        SectionPage.screenName: (context) => SectionPage(),
        EditProfileScreen.screenName: (context) => EditProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == OtpVerificationScreen.screenName) {
          final args = settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(builder: (context) {
            return OtpVerificationScreen(
              email: args["email"],
            );
          });
        }
        if (settings.name == AskUserInfo.screenName) {
          final args = settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(builder: (context) {
            return AskUserInfo(
              email: args["email"],
              callbacktoken: args["callbacktoken"],
            );
          });
        }
        if (settings.name == CommentsDetailedPage.screenName) {
          final args = settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(builder: (context) {
            return CommentsDetailedPage(
              id: args["id"],
              shouldOpenkeyboard: args["shouldOpenkeyboard"],
              replyCount: args["replyCount"],
              message: args["message"],
              username: args["username"],
              time: args["time"],
              userProfileImageLink: args["userProfileImageLink"],
              optionChoosen: args["optionChoosen"],
            );
          });
        }
        if (settings.name == PostDetailedPage.screenName) {
          final args = settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(builder: (context) {
            return PostDetailedPage(
              title: args["title"],
              description: args["description"],
              imageUrl: args["imageUrl"],
              totalComments: args["totalComments"],
              username: args["username"],
              id: args["id"],
              token: args["token"],
              bookmarked: args["bookmarked"],
              votable: args["votable"],
              option1text: args["option1text"],
              option2text: args["option2text"],
              option3text: args["option3text"],
              option4text: args["option4text"],
              option1votes: args["option1votes"],
              option2votes: args["option2votes"],
              option3votes: args["option3votes"],
              option4votes: args["option4votes"],
              optionChoosen: args["optionChoosen"],
            );
          });
        }
        if (settings.name == ShowUserProfile.screenName) {
          final args = settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(builder: (context) {
            return ShowUserProfile(
              username: args["username"],
              // fullname: args['fullname'],
              // userProfilePicLink: args['userProfilePicLink'],
              // following: args['following'],
              // title: args['title'],
              // about: args['about'],
              // id: args['id'],
            );
          });
        }

        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}

void preInit(BuildContext context) async {
  await Hive.openBox("settings");

  bool settingsExist = Hive.box('settings').length != 0;

  if (settingsExist) {
    final settings = Hive.box('settings').getAt(0) as Settings;
    context.read(disableAllNotifBoolProvider).state =
        settings.disableAllNotifBool;
    context.read(commentNotifBoolProvider).state = settings.commentNotifBool;
    context.read(replyNotifBoolProvider).state = settings.replyNotifBool;
    context.read(voteNotifBoolProvider).state = settings.voteNotifBool;
    context.read(mentionNotifBoolProvider).state = settings.mentionNotifBool;
    context.read(showOptionsBoolProvider).state = settings.showOptionsBool;
  } else {
    Hive.box('settings').add(Settings(
      disableAllNotifBool: false,
      commentNotifBool: true,
      voteNotifBool: true,
      showOptionsBool: true,
      mentionNotifBool: true,
      replyNotifBool: true,
    ));
  }
  await Hive.openBox("userDetails");

  bool userDetailsExist = Hive.box('userDetails').length != 0;

  if (userDetailsExist) {
    final settings = Hive.box('userDetails').getAt(0) as UserDetails;
    context.read(currentUserDetailsProvider).state = settings;
  } else {
    context.read(authenticationStatusProvider).state =
        AuthenticationStatus.notAuthenticated;
    return;
    // Hive.box('settings').add(Settings(
    //   disableAllNotifBool: false,
    //   commentNotifBool: true,
    //   voteNotifBool: true,
    //   showOptionsBool: true,
    //   mentionNotifBool: true,
    //   replyNotifBool: true,
    // ));
  }

  final storage = FlutterSecureStorage();
  String? value = await storage.read(key: kLoginToken);
  if (value != null) {
    context.read(tokenProvider).state = value;
    context.read(authenticationStatusProvider).state =
        AuthenticationStatus.authenticated;
    generateDeviceToken(value);
    // String? deviceToken = await FirebaseMessaging.instance.getToken();
    // print(deviceToken);
    // String? token = value;
    // saveDeviceTokenToDatabase(deviceToken!,token);
    // FirebaseMessaging.instance.onTokenRefresh.listen((String s)=>{saveDeviceTokenToDatabase(s,token)});
    
  } else {
    context.read(authenticationStatusProvider).state =
        AuthenticationStatus.notAuthenticated;
  }
}

void _handleMessage(RemoteMessage message) {
    // if (message.data['type'] == 'chat') {
    //   Navigator.pushNamed(context, '/chat', 
    //     arguments: ChatArguments(message),
    //   );
    // }
  }

void setupNotif() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage); 
  
}



