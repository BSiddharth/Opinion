import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:opinion_frontend/components/showProfilePicture.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/screens/postsPage.dart';
import 'package:opinion_frontend/services/followUnfollow.dart';
import 'package:opinion_frontend/services/getUserDetails.dart';
import 'package:opinion_frontend/services/glowRemover.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowUserProfile extends StatefulWidget {
  static const screenName = '/showUserProfile';
  ShowUserProfile({
    required this.username,
    // required this.fullname,
    // required this.userProfilePicLink,
    // required this.following,
    // required this.id,
    // required this.title,
    // required this.about,
  });
  final String username;
  // final String userProfilePicLink;
  // final String fullname;
  // final String following;
  // final String id;
  // final String title;
  // final String about;

  @override
  _ShowUserProfileState createState() => _ShowUserProfileState();
}

class _ShowUserProfileState extends State<ShowUserProfile> {
  String? amIFollowing;
  String message = 'Loading';
  String? id;
  String? userProfilePicLink;
  String? fullname;
  String? title;
  String? about;
  bool isLoading = true;
  @override
  void initState() {
    userDetails(username: widget.username);
    super.initState();
  }

  void userDetails({required String username}) async {
    final response = await getUserDetails(
        token: context.read(tokenProvider).state!, username: username);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(json.decode(response.body));
      setState(() {
        amIFollowing = data['following'];
        id = data['id'];
        userProfilePicLink = data['profilePicLink'];
        fullname = data['fullname'];
        title = data['description'];
        about = data['about'];
        isLoading = false;
      });
    } else {
      setState(() {
        message = 'Some error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: !isLoading
          ? Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(widget.username),
                titleSpacing: 0.0,
                actions: [
                  IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      onPressed: null)
                ],
              ),
              body: GlowRemover(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ShowProfilePicture(
                              url: userProfilePicLink!, dimension: 120),
                          Text(
                            fullname!,
                            style: TextStyle(
                                fontFamily: "Baloo",
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                                // height: 1,
                                ),
                          ),
                          Text(
                            title!,
                            style: TextStyle(
                              fontSize: 15,
                              // fontWeight: FontWeight.w600,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    about != ''
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ExpandableText(
                                  about!,
                                  expandText: 'show more',
                                  collapseText: 'show less',
                                  maxLines: 3,
                                  linkColor: Colors.white60,
                                  style: TextStyle(
                                    fontSize: 15,
                                    // fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0),
                      // padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                primary: amIFollowing == 'true'
                                    ? Colors.black
                                    : Colors.redAccent,
                                backgroundColor: amIFollowing == 'true'
                                    ? Colors.black
                                    : Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: amIFollowing == 'true'
                                      ? BorderSide(color: Colors.redAccent)
                                      : BorderSide.none,
                                ),
                              ),
                              // padding: EdgeInsets.symmetric(horizontal: 60),
                              onPressed: () {
                                if (amIFollowing == 'true') {
                                  setState(() {
                                    amIFollowing = 'false';
                                  });
                                  followUnfollow(
                                      userId: id!,
                                      token: context.read(tokenProvider).state!,
                                      followOrUnfollow: 'unfollow');
                                } else {
                                  setState(() {
                                    amIFollowing = 'true';
                                  });
                                  followUnfollow(
                                      userId: id!,
                                      token: context.read(tokenProvider).state!,
                                      followOrUnfollow: 'follow');
                                }
                              },
                              child: Text(
                                amIFollowing == 'true' ? "Following" : 'Follow',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 5,
                          // ),
                          // FlatButton(
                          //   padding: EdgeInsets.symmetric(horizontal: 30),
                          //   onPressed: () {},
                          //   child: Text(
                          //     "Message",
                          //     style: TextStyle(fontSize: 16, color: Colors.white),
                          //   ),
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(8.0),
                          //       side: BorderSide(color: Colors.red)),
                          // ),
                          // SizedBox(
                          //   width: 5,
                          // ),
                          // ButtonTheme(
                          //   padding: EdgeInsets.symmetric(
                          //       vertical: 4.0,
                          //       horizontal: 8.0), //adds padding inside the button
                          //   materialTapTargetSize: MaterialTapTargetSize
                          //       .shrinkWrap, //limits the touch area to the button area
                          //   minWidth: 0, //wraps child's width

                          //   child: FlatButton(
                          //     onPressed: () {},
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(0.0),
                          //       child: Icon(
                          //         Icons.keyboard_arrow_down,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(8.0),
                          //         side: BorderSide(color: Colors.red)),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    // PostPreShowcaseWidget(
                    //   profilePicUrl:
                    //       "https://www.clipartkey.com/mpngs/m/48-480137_bjp-logo-png-clipart-logo-bharatiya-janata-party.png",
                    //   userName: "BJP_Official",
                    //   title: "Citizenship Amendment Act (CAA)",
                    //   imageUrl:
                    //       "https://www.livelaw.in/h-upload/2019/12/14/368013-citizenship-amendment-act-and-sc-02.jpg",
                    //   section: "Laws and Policies",
                    //   option1votes: 15000,
                    //   option2votes: 60000,
                    //   option3votes: 49000,
                    //   option4votes: 9000,
                    //   description: '',
                    //   option1text: '',
                    //   option2text: '',
                    //   option3text: '',
                    //   option4text: '',
                    //   time: '',
                    //   totalComments: 5001135,
                    //   votable: 'false',
                    // ),
                    // PostPreShowcaseWidget(
                    //   profilePicUrl:
                    //       "https://www.hindustantimes.com/rf/image_size_640x362/HT/p1/2014/02/27/Incoming/Pictures/1188878_Wallpaper2.jpg",
                    //   userName: "AAP_Official",
                    //   title: "Happiness Class Initiative",
                    //   imageUrl:
                    //       "https://d1i4t8bqe7zgj6.cloudfront.net/07-19-2018/t_1532032053933_name_1920_india_happiness_scaled.jpg",
                    //   section: "Laws and Policies",
                    //   option1votes: 155000,
                    //   option2votes: 60000,
                    //   option3votes: 15000,
                    //   option4votes: 15000,
                    //   description: '',
                    //   option1text: '',
                    //   option2text: '',
                    //   option3text: '',
                    //   option4text: '',
                    //   time: '',
                    //   totalComments: 5001135,
                    //   votable: 'false',
                    // ),
                    // PostPreShowcaseWidget(
                    //   imageUrl:
                    //       "https://www.universetoday.com/wp-content/uploads/2019/03/Starship-reentry-Earth-SpaceX-1-crop-5-edit-1.jpg",
                    //   profilePicUrl:
                    //       "https://media.beam.usnews.com/d1/d8/8501ba714a21aed9a7327e02ade1/180515-10thingselonmusk-editorial.jpg",
                    //   title:
                    //       "Do you guys think my starship is a practical idea? Would you want to go to mars in it?",
                    //   userName: "MuskyElon_Official",
                    //   section: "Science and Technology",
                    //   option1votes: 40000,
                    //   option2votes: 8650,
                    //   option3votes: 23600,
                    //   option4votes: 9000,
                    //   description: '',
                    //   option1text: '',
                    //   option2text: '',
                    //   option3text: '',
                    //   option4text: '',
                    //   time: '',
                    //   totalComments: 5001135,
                    //   votable: 'false',
                    // ),

                    Expanded(child: PostsPage(username: widget.username)),
                  ],
                ),
              ),
            )
          : Scaffold(
              backgroundColor: Colors.black,
              body: Container(
                child: Center(
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
    );
  }
}

// class UserStatsWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             DataNameColumn(
//               name: "Followers",
//               data: "549",
//             ),
//             DataNameColumn(
//               name: "Following",
//               data: "312",
//             ),
//             DataNameColumn(
//               name: "Posts",
//               data: "62",
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             DataNameColumn(
//               name: "Questions",
//               data: "2",
//             ),
//             DataNameColumn(
//               name: "Answers",
//               data: "23",
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class DataNameColumn extends StatelessWidget {
//   DataNameColumn({required this.data, required this.name});
//   final String data;
//   final String name;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           data,
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         Text(name, style: TextStyle(color: Colors.black54)),
//       ],
//     );
//   }
// }
