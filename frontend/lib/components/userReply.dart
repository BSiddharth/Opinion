import 'package:flutter/material.dart';
import 'package:opinion_frontend/components/darkDivider.dart';
import 'package:opinion_frontend/components/showProfilePicture.dart';

import 'optionChoosen.dart';

class UserReply extends StatelessWidget {
  UserReply({
    required this.time,
    required this.message,
    required this.userProfileImageLink,
    required this.username,
  });

  final String time;
  final String message;
  final String userProfileImageLink;
  final String username;

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
                      Icon(
                        Icons.fiber_manual_record,
                        size: 5,
                        color: Colors.white60,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      OptionChoosen(
                        optionChoosen: 'A',
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
          padding: const EdgeInsets.fromLTRB(53, 10, 10, 10),
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
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(53, 0, 10, 10),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Icon(
        //         Icons.more_vert,
        //         color: Colors.white60,
        //       )
        //     ],
        //   ),
        // ),
        DarkDivider(height: 2),
      ],
    );
  }
}
