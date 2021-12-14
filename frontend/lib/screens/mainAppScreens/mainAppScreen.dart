import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:opinion_frontend/components/mainAppBar.dart';
import 'package:opinion_frontend/components/showProfilePicture.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/screens/mainAppScreens/addPostPage.dart';
import 'package:opinion_frontend/screens/mainAppScreens/homePage.dart';
import 'package:opinion_frontend/screens/mainAppScreens/notificationPage.dart';
import 'package:opinion_frontend/screens/mainAppScreens/profilePageScreens/profilePage.dart';
import 'package:opinion_frontend/screens/mainAppScreens/searchPages/searchPage.dart';
import 'package:opinion_frontend/screens/settingsPage.dart';
import 'package:opinion_frontend/services/logOut.dart';

final timerBoolProvider = StateProvider<bool>((ref) => false);

class MainAppScreen extends ConsumerWidget {
  static const screenName = '/mainscreen';
  final Widget? currentAppBar = MainAppBar();
  final TextStyle listTileTitleStyle = TextStyle(
    fontSize: 15,
    color: Colors.white,
  );
  final _screenList = [
    HomePage(),
    SearchPage(),
    AddPostPage(),
    NotificationPage(),
    ProfilePage(),
  ];
  
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userDetails = context.read(currentUserDetailsProvider).state;
    void _startTimeout() {
      context.read(timerBoolProvider).state = true;
      Timer(Duration(seconds: 2), () {
        context.read(timerBoolProvider).state = false;
      });
    }

    void _showToast() {
      Fluttertoast.showToast(
        msg: "Press back again to exit",
        toastLength: Toast.LENGTH_SHORT,
      );
    }

    void _onItemTapped(int index) {
      if (index != 0) {
        context.read(currentAppBarProvider).state = null;
      } else {
        context.read(currentAppBarProvider).state = MainAppBar();
      }

      context.read(currentIndexProvider).state = index;
    }

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (context.read(currentIndexProvider).state != 0) {
            _onItemTapped(0);
            return false;
          } else {
            if (!context.read(timerBoolProvider).state) {
              _startTimeout();
              _showToast();
              return false;
            } else {
              Hive.close();
              return true;
            }
          }
        },
        child: Scaffold(
          // app bar is used here so that drawer can cover the bottomnavbar
          appBar: watch(currentAppBarProvider).state,
          drawer: Drawer(
            child: Container(
              color: Colors.black87,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            // _onItemTapped(4);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ShowProfilePicture(
                                  url: userDetails.userprofileimagelink,
                                  dimension: 70),
                              SizedBox(
                                width: 8.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${userDetails.firstname} ${userDetails.lastname}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  Text(
                                    userDetails.username,
                                    style: TextStyle(
                                      color: Colors.white60,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                logOut(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.exit_to_app,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Log Out",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side:
                                        BorderSide(color: Colors.transparent)),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side:
                                        BorderSide(color: Colors.transparent)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                    context, SettingsPage.screenName);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.settings_outlined,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Settings",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 1,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    color: Colors.white,
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                    child: Text(
                      "Sections",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 15,
                        fontFamily: "Baloo",
                      ),
                    ),
                  ),
                  ListTile(
                    leading: ListTileImage("assets/images/trending.png"),
                    title: Text(
                      'Trending',
                      style: listTileTitleStyle,
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    leading: ListTileImage("assets/images/general.jpg"),
                    title: Text(
                      'General',
                      style: listTileTitleStyle,
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    leading: ListTileImage("assets/images/policies.jpg"),
                    title: Text(
                      'Law And Policies',
                      style: listTileTitleStyle,
                    ),
                    onTap: () {
                      // Navigator.pop(context);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (BuildContext context) => LawAndPoliciesPage(),
                      //   ),
                      // );
                    },
                  ),
                  ListTile(
                    leading: ListTileImage("assets/images/government.jpg"),
                    title: Text(
                      'Government',
                      style: listTileTitleStyle,
                    ),
                    onTap: () {
                      // Navigator.pop(context);

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (BuildContext context) =>
                      //         SelectGovernmentPage(),
                      //   ),
                      // );
                    },
                  ),
                  ListTile(
                    leading: ListTileImage("assets/images/movies.jpg"),
                    title: Text(
                      'Movies and TvShows',
                      style: listTileTitleStyle,
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: ListTileImage("assets/images/random.jpg"),
                    title: Text(
                      'Random',
                      style: listTileTitleStyle,
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedIconTheme: IconThemeData(size: 30, color: Colors.white),
            unselectedIconTheme: IconThemeData(size: 30, color: Colors.white60),
            backgroundColor: Colors.black,
            currentIndex: context.read(currentIndexProvider).state,
            selectedItemColor: Colors.white,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                // icon: Icon(OMIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline_rounded),
                label: 'Add Post',
              ),
              BottomNavigationBarItem(
                // icon: Icon(Icons.notifications_active),
                icon: Icon(Icons.notifications_none_outlined),
                label: 'Notification',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                label: 'Personal Page',
              ),
            ],
          ),
          body: _screenList.elementAt(watch(currentIndexProvider).state),
        ),
      ),
    );

    // Scaffold(
    //     body: Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     Consumer(builder: (context, watch, child) {
    //       return TextButton(
    //         onPressed: () async {
    //           context.read(authenticationStatusProvider).state =
    //               AuthenticationStatus.notAuthenticated;
    //           context.read(tokenProvider).state = null;
    //           final storage = FlutterSecureStorage();
    //           await storage.delete(key: kLoginToken);
    //         },
    //         child: Text('Logout'),
    //       );
    //     }),
    //   ],
    // ));
  }
}

class ListTileImage extends StatelessWidget {
  const ListTileImage(this.imageString);
  final imageString;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(
        imageString,
        height: 40,
        width: 40,
        fit: BoxFit.cover,
      ),
    );
  }
}
