import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:opinion_frontend/components/showProfilePicture.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/screens/editProfileScreen.dart';
import 'package:opinion_frontend/screens/mainAppScreens/profilePageScreens/profile_page_followers.dart';
import 'package:opinion_frontend/screens/mainAppScreens/profilePageScreens/profile_page_following.dart';
import 'package:opinion_frontend/screens/mainAppScreens/profilePageScreens/profile_page_participated.dart';
import 'package:opinion_frontend/screens/postsPage.dart';
import 'package:opinion_frontend/screens/settingsPage.dart';
import 'package:opinion_frontend/services/glowRemover.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const screenName = '/profilepage';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userDetails = context.read(currentUserDetailsProvider).state;
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: GlowRemover(
            child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          children: [
                            ShowProfilePicture(
                              url: userDetails.userprofileimagelink,
                              dimension: 120,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${userDetails.firstname} ${userDetails.lastname}",
                              style: TextStyle(
                                fontFamily: "Baloo",
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                // height: 1,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              userDetails.title,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                      userDetails.about == ''
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ExpandableText(
                                    userDetails.about,
                                    expandText: 'show more',
                                    collapseText: 'show less',
                                    maxLines: 3,
                                    linkColor: Colors.white60,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(color: Colors.redAccent),
                                  )),

                              // color: Colors.orange,
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => Settings(),
                                //   ),
                                // );
                                Navigator.pushNamed(
                                    context, SettingsPage.screenName);
                              },
                              child: Text(
                                "Settings",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  // side: BorderSide(color: Colors.red),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, EditProfileScreen.screenName);
                              },
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ];
              },
              body: Column(
                children: [
                  TabBar(
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                          icon: Icon(
                        Icons.subtitles_rounded,

                        // OMIcons.subtitles,
                        color: Colors.white,
                      )),
                      Tab(
                          icon: Icon(
                        Icons.poll_rounded,
                        color: Colors.white,
                      )),
                      Tab(
                          icon: Icon(
                        Icons.person_outline_rounded,
                        color: Colors.white,
                      )),
                      Tab(
                          icon: SvgPicture.asset(
                        "assets/svg/groups.svg",
                        height: 32,
                        width: 32,
                        color: Colors.white,
                      )),
                      // Tab(
                      //     icon: Center(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Icon(
                      //         Icons.bookmarks_outlined,
                      //         color: Colors.black,
                      //       ),
                      //       Icon(
                      //         Icons.add,
                      //         color: Colors.black,
                      //       ),
                      //     ],
                      //   ),
                      // )),
                    ],
                  ),
                  Expanded(
                      child: TabBarView(
                    children: [
                      PostsPage(
                        username: context
                            .read(currentUserDetailsProvider)
                            .state
                            .username,
                      ),
                      ProfilePageParticipated(),
                      ProfilePageFollowers(),
                      ProfilePageFollowing(),
                      // ListView(
                      //   children: [
                      //     Text(
                      //       "Following jinhe tum kar rhe ho",
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
