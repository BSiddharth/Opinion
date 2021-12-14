import 'package:flutter/material.dart';
import 'package:opinion_frontend/components/showProfilePicture.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/screens/showUserProfile.dart';
import 'package:opinion_frontend/services/followUnfollow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MiniUserTile extends StatefulWidget {
  MiniUserTile({
    required this.userProfilePicLink,
    required this.following,
    required this.username,
    required this.fullname,
    required this.id,
    // required this.title,
    // required this.about,
  });
  final String userProfilePicLink;
  final String username;
  final String fullname;
  final String following;
  final String id;
  // final String title;
  // final String about;

  @override
  _MiniUserTileState createState() => _MiniUserTileState();
}

class _MiniUserTileState extends State<MiniUserTile> {
  String? amIFollowing;
  @override
  void initState() {
    setState(() {
      amIFollowing = widget.following;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                ShowUserProfile.screenName,
                arguments: {
                  'username': widget.username,
                  // 'userProfilePicLink': widget.userProfilePicLink,
                  // 'fullname': widget.fullname,
                  // 'id': widget.id,
                  // 'following': amIFollowing,
                  // 'title': widget.title,
                  // 'about': widget.about,
                },
              );
            },
            child: Row(
              children: [
                ShowProfilePicture(
                  url: widget.userProfilePicLink,
                  dimension: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    Text(
                      widget.fullname,
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: SizedBox()),
          TextButton(
            style: TextButton.styleFrom(
              primary: amIFollowing == 'true' ? Colors.black : Colors.redAccent,
              backgroundColor:
                  amIFollowing == 'true' ? Colors.black : Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: amIFollowing == 'true'
                    ? BorderSide(color: Colors.redAccent)
                    : BorderSide.none,
              ),
            ),
            onPressed: () {
              if (amIFollowing == 'true') {
                setState(() {
                  amIFollowing = 'false';
                });
                followUnfollow(
                    userId: widget.id,
                    token: context.read(tokenProvider).state!,
                    followOrUnfollow: 'unfollow');
              } else {
                setState(() {
                  amIFollowing = 'true';
                });
                followUnfollow(
                    userId: widget.id,
                    token: context.read(tokenProvider).state!,
                    followOrUnfollow: 'follow');
              }
            },
            child: Text(
              amIFollowing == 'true' ? "Following" : 'Follow',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
