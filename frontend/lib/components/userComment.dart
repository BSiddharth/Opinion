import 'package:flutter/material.dart';
import 'package:opinion_frontend/components/darkDivider.dart';
import 'package:opinion_frontend/components/optionChoosen.dart';
import 'package:opinion_frontend/components/showProfilePicture.dart';
import 'package:opinion_frontend/screens/commentDetailedPage.dart';

class UserComment extends StatelessWidget {
  UserComment({
    required this.id,
    required this.replyCount,
    required this.time,
    required this.message,
    required this.userProfileImageLink,
    required this.username,
    required this.optionChoosen,
  });
  final String id;
  final String replyCount;
  final String time;
  final String message;
  final String userProfileImageLink;
  final String username;
  final String optionChoosen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 10.0, 3.0),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShowProfilePicture(
                dimension: 40,
                url: userProfileImageLink,
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        username,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // fontFamily: "Baloo",
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      optionChoosen == ""
                          ? Container()
                          : Icon(
                              Icons.fiber_manual_record,
                              size: 5,
                              color: Colors.white60,
                            ),
                      SizedBox(
                        width: 4,
                      ),
                      optionChoosen == ""
                          ? Container()
                          : OptionChoosen(
                              optionChoosen: optionChoosen,
                            )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontFamily: "Baloo",
                      fontSize: 14.5,
                      color: Colors.white60,
                      height: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(53, 10, 10, 0),
          child: Text(
            message,
            style: TextStyle(
              fontFamily: "Baloo",
              fontSize: 15,
              color: Colors.white,
              height: 1,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(53, 0, 10, 0),
          child: Row(
            children: [
              replyCount != '0'
                  ? Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            minimumSize: Size(0, 0),
                            primary: Colors.transparent,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              CommentsDetailedPage.screenName,
                              arguments: {
                                "shouldOpenkeyboard": false,
                                "id": id,
                                "replyCount": replyCount,
                                'message': message,
                                'time': time,
                                'userProfileImageLink': userProfileImageLink,
                                'username': username,
                                'optionChoosen': optionChoosen,
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                replyCount,
                                style: TextStyle(
                                  color: Colors.white60,
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                replyCount != '1' ? "Replies" : 'Reply',
                                style: TextStyle(
                                  color: Colors.white60,
                                ),
                              ),
                              // SizedBox(
                              //   width: 3,
                              // ),
                              // Icon(
                              //   Icons.fiber_manual_record,
                              //   size: 6,
                              //   color: Colors.white60,
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )
                  : Container(),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  minimumSize: Size(0, 0),
                  primary: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    CommentsDetailedPage.screenName,
                    arguments: {
                      "shouldOpenkeyboard": true,
                      "id": id,
                      "replyCount": replyCount,
                      'message': message,
                      'time': time,
                      'userProfileImageLink': userProfileImageLink,
                      'username': username,
                      'optionChoosen': optionChoosen,
                    },
                  );
                },
                child: Text(
                  "Reply",
                  style: TextStyle(
                    color: Colors.white60,
                  ),
                ),
              ),
              Spacer(),
              Icon(
                Icons.more_vert,
                color: Colors.white60,
              )
            ],
          ),
        ),
        DarkDivider(height: 2),
      ],
    );
  }
}
