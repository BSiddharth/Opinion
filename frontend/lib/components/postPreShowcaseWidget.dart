import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:opinion_frontend/components/darkDivider.dart';
import 'package:opinion_frontend/components/iconsWithName.dart';
import 'package:opinion_frontend/components/showProfilePicture.dart';
import 'package:opinion_frontend/components/voteShareIndicator.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/screens/showUserProfile.dart';
import 'package:opinion_frontend/screens/postDetailedPage.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PostPreShowcaseWidget extends ConsumerWidget {
  const PostPreShowcaseWidget({
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
  final String optionChoosen;
  final int option1votes;
  final int option2votes;
  final int option3votes;
  final int option4votes;
  final int totalComments;
  final String votable;
  final double iconSize = 23;
  final double iconTextSize = 14;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final bool shouldShowOptions = watch(showOptionsBoolProvider).state;
    final int totalVotes =
        option1votes + option2votes + option3votes + option4votes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: votable == 'true',
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              children: [
                Text(
                  section,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                Expanded(child: SizedBox()),
                GestureDetector(
                  child: Icon(
                    Icons.view_headline,
                    color: Colors.grey[600],
                    size: 25,
                  ),
                  onTap: () {
                    context.read(showOptionsBoolProvider).state =
                        !context.read(showOptionsBoolProvider).state;
                  },
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.pushNamed(context, ShowUserProfile.screenName,
                arguments: {
                  'username': userName,
                  // 'userProfilePicLink': profilePicUrl,
                  // 'fullname': userName,
                  // 'fullname': widget.fullname,
                  // 'id': widget.id,
                  // 'following': amIFollowing,
                  // 'title': widget.title,
                  // 'about': widget.about,
                });
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShowProfilePicture(
                  url: profilePicUrl,
                  dimension: 40,
                ),
                SizedBox(
                  width: 7,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                              // fontFamily: "Baloo",
                              fontSize: 14,
                              // height: 0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ],
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         SizedBox(
                //           height: 15,
                //         ),
                //         Text(
                //           userName,
                //           style: TextStyle(
                //               fontFamily: "Baloo",
                //               fontSize: 16,
                //               height: 0,
                //               fontWeight: FontWeight.w600,
                //               color: Colors.white),
                //         ),
                //         SizedBox(
                //           height: 5,
                //         ),
                //         Text(
                //           time,
                //           // "12h",
                //           style: TextStyle(
                //             // fontFamily: "Baloo",
                //             fontSize: 10,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ],
                //     ),
                //     SizedBox(
                //       width: 2,
                //     ),
                //     Icon(
                //       Icons.verified,
                //       color: Colors.blue,
                //       size: 20,
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
        Visibility(
          visible: title != "",
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontFamily: "Baloo",
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                height: 1.1,
                color: Colors.white,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, PostDetailedPage.screenName,
                arguments: {
                  'title': title,
                  "description": description,
                  "imageUrl": imageUrl,
                  "totalComments": NumberFormat.compact().format(totalComments),
                  "username": userName,
                  'id': id,
                  'token': context.read(tokenProvider).state!,
                  'bookmarked': bookmarked == 'true' ? true : false,
                  'votable': votable == 'true' ? true : false,
                  'option1text': option1text,
                  'option2text': option2text,
                  'option3text': option3text,
                  'option4text': option4text,
                  'option1votes': option1votes,
                  'option2votes': option2votes,
                  'option3votes': option3votes,
                  'option4votes': option4votes,
                  'optionChoosen': optionChoosen,
                });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                fadeInDuration: Duration(milliseconds: 0),
                fadeOutDuration: Duration(milliseconds: 0),
                color: Color(0xFF707070),
                height: 400,
                imageUrl: imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF707070),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter: shouldShowOptions && votable == 'true'
                          ? ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.dstATop)
                          : ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.color,
                            ),
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  width: double.infinity,
                  height: 400.0,
                  color: Colors.grey,
                  // child: Shimmer.fromColors(
                  //   enabled: true,
                  //   period: Duration(milliseconds: 500),
                  //   baseColor: Colors.grey,
                  //   highlightColor: Colors.grey[400],
                  //   child: Container(
                  //     color: Colors.white,
                  //   ),
                  // ),
                ),
                // Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: Colors.redAccent,
                ),
              ),
              // Container(
              //   height: 350,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       colorFilter: shouldShowOptions
              //           ? ColorFilter.mode(
              //               Colors.black.withOpacity(0.4), BlendMode.dstATop)
              //           : ColorFilter.mode(
              //               Colors.transparent,
              //               BlendMode.color,
              //             ),
              //       image: NetworkImage(widget.imageUrl),
              //       fit: BoxFit.cover,
              //     ),
              //     color: Color(0xFF707070),
              //   ),
              // ),
              Visibility(
                visible: shouldShowOptions && votable == 'true',
                child: Container(
                  height: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // Visibility(
                      //   visible: option1text != "",
                      //   child: ShowVoteOptions(
                      //     optionString: option1text,
                      //   ),
                      // ),
                      ShowVoteOptions(
                        optionString: option1text,
                      ),
                      ShowVoteOptions(
                        optionString: option2text,
                      ),
                      ShowVoteOptions(
                        optionString: option3text,
                      ),
                      ShowVoteOptions(
                        optionString: option4text,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: votable == 'true',
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: VoteShareIndicator(
                    option1: option1votes,
                    option2: option2votes,
                    option3: option3votes,
                    option4: option4votes,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "Total votes: ${NumberFormat.compact().format(totalVotes)}",
                  style: TextStyle(
                    fontFamily: "Baloo",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: votable == 'true'
              ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
              // ? const EdgeInsets.fromLTRB(10, 0, 10, 10)
              : const EdgeInsets.fromLTRB(0, 0, 0, 0),
          // : const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            children: [
              BookmarkButton(
                postId: id,
                token: context.read(tokenProvider).state!,
                bookmarked: bookmarked == 'true' ? true : false,
              ),
              SizedBox(
                width: 20,
              ),
              ShareButton(),
              Spacer(),
              CommentButton(
                totalCommentsString:
                    NumberFormat.compact().format(totalComments),
              ),
              // NumberFormat.compact().format(totalComments),

              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.more_vert,
                // color: Colors.grey[700],
                color: Colors.white,

                size: iconSize,
              ),
            ],
          ),
        ),
        DarkDivider(
          height: 5,
        )
      ],
    );
  }
}

class ShowVoteOptions extends StatelessWidget {
  const ShowVoteOptions({
    required this.optionString,
  });
  final String optionString;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 8.0,
          ),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: AutoSizeText(
                  optionString.replaceAll("", "\u{200B}"),
                  maxLines: 2,
                  minFontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Baloo",
                    height: 1,
                    fontSize: 16,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.5, 1.1),
                        blurRadius: 5.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 10,
          child: ShowProfilePicture(
            dimension: 25,
            url:
                "https://infotonline.com/wp-content/uploads/2020/05/Jethalal.jpg",
          ),
        ),
        Positioned(
          bottom: 0,
          right: 25,
          child: ShowProfilePicture(
            dimension: 25,
            url:
                "https://thumbor.forbes.com/thumbor/fit-in/416x416/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fimageserve%2F5ed579d37bd7a20006bef454%2F0x0.jpg%3Fbackground%3D000000%26cropX1%3D485%26cropX2%3D1365%26cropY1%3D0%26cropY2%3D880",
          ),
        ),
        Positioned(
          bottom: 0,
          right: 40,
          child: ShowProfilePicture(
            dimension: 25,
            url:
                "https://cdn.dnaindia.com/sites/default/files/styles/full/public/2019/09/27/871134-sitharaman-nirmala-pti-092719.jpg",
          ),
        ),
      ],
    );
  }
}
