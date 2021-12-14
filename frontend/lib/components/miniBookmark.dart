import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:opinion_frontend/components/showProfilePicture.dart';
import 'package:opinion_frontend/components/voteShareIndicator.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/screens/postDetailedPage.dart';

class MiniBookmark extends ConsumerWidget {
  const MiniBookmark({
    required this.imageUrl,
    required this.profilePicUrl,
    required this.title,
    required this.userName,
    required this.section,
    required this.time,
    required this.description,
    required this.option1votes,
    required this.option2votes,
    required this.option3votes,
    required this.option4votes,
    required this.option1text,
    required this.option2text,
    required this.option3text,
    required this.option4text,
    required this.votable,
    required this.totalComments,
    required this.id,
    required this.bookmarked,
    required this.optionChoosen,
  });

  final String profilePicUrl;
  final String userName;
  final String title;
  final String imageUrl;
  final String time;
  final String section;
  final String description;
  final String option1text;
  final String option2text;
  final String option3text;
  final String option4text;
  final String id;
  final String bookmarked;
  final int option1votes;
  final int option2votes;
  final int option3votes;
  final int option4votes;
  final int totalComments;
  final String votable;
  final String optionChoosen;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      // child: CachedNetw
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            PostDetailedPage.screenName,
            arguments: {
              'title': title,
              "description": description,
              "imageUrl": imageUrl,
              "totalComments": NumberFormat.compact().format(totalComments),
              "username": userName,
              'id': id,
              'token': context.read(tokenProvider).state!,
              'bookmarked': bookmarked == 'true' ? true : false,
              'option1text': option1text,
              'option2text': option2text,
              'option3text': option3text,
              'option4text': option4text,
              'option1votes': option1votes,
              'option2votes': option2votes,
              'option3votes': option3votes,
              'option4votes': option4votes,
              'votable': votable == 'true' ? true : false,
              'optionChoosen': optionChoosen,
            },
          );
        },
        child: Container(
            width: 350,
            decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4), BlendMode.dstATop),
                  image: CachedNetworkImageProvider(
                    imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
                // the next line keeps the bookmark's background whitish
                color: Color(0xFF707070),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 18, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ShowProfilePicture(
                        url: profilePicUrl,
                        dimension: 40,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                userName,
                                style: TextStyle(
                                  fontFamily: "Baloo",
                                  fontSize: 15,
                                  height: 0,
                                  fontWeight: FontWeight.w600,
                                  // color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                time,
                                style: TextStyle(
                                    // fontFamily: "Baloo",
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600
                                    // color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Baloo",
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.5, 1.1),
                          blurRadius: 5.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: VoteShareIndicator(
                    option1: option1votes,
                    option2: option2votes,
                    option3: option3votes,
                    option4: option4votes,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
