import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jiffy/jiffy.dart';
import 'package:opinion_frontend/components/barCharts.dart';
import 'package:opinion_frontend/components/commentBox.dart';
import 'package:opinion_frontend/components/darkDivider.dart';
import 'package:opinion_frontend/components/iconsWithName.dart';
import 'package:opinion_frontend/components/userComment.dart';
import 'package:opinion_frontend/const.dart';
import 'package:opinion_frontend/services/getComments.dart';
import 'package:opinion_frontend/services/glowRemover.dart';
import 'package:opinion_frontend/services/voteOnPost.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PostDetailedPage extends StatefulWidget {
  static const screenName = '/voteDetailedPage';
  PostDetailedPage({
    required this.username,
    required this.title,
    required this.totalComments,
    required this.imageUrl,
    required this.description,
    required this.id,
    required this.token,
    required this.option1text,
    required this.option2text,
    required this.option3text,
    required this.option4text,
    required this.option1votes,
    required this.option2votes,
    required this.option3votes,
    required this.option4votes,
    required this.bookmarked,
    required this.votable,
    required this.optionChoosen,
  });
  final String username;
  final String title;
  final String totalComments;
  final String imageUrl;
  final String description;
  final String id;
  final String token;
  final String option1text;
  final String option2text;
  final String option3text;
  final String option4text;
  final int option1votes;
  final int option2votes;
  final int option3votes;
  final int option4votes;
  final bool bookmarked;
  final bool votable;
  final String optionChoosen;

  @override
  _PostDetailedPageState createState() => _PostDetailedPageState();
}

class _PostDetailedPageState extends State<PostDetailedPage> {
  void changeOption(String label) {
    setState(() {
      optionLabel = label;
    });
  }

  void changeCurrentOption() {
    setState(() {
      currentLabel = optionLabel;
    });
  }

  @override
  void initState() {
    currentLabel = widget.optionChoosen;
    super.initState();
  }

  final PageController _pageController = PageController(
    initialPage: 0,
  );
  String optionLabel = '';
  String currentLabel = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          titleSpacing: 0,
          title: Row(
            children: [
              Text(widget.username),
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
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            )
          ],
        ),
        body: GlowRemover(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),

              widget.votable
                  ? Container(
                      height: 550,
                      child: PageView(
                        controller: _pageController,
                        children: [
                          Column(
                            children: [
                              Container(
                                  // color: Colors.white,
                                  color: const Color(0xff2c4260),
                                  height: 298,
                                  child: ListView(
                                    children: [
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //     horizontal: 10,
                                      //     vertical: 8,
                                      //   ),
                                      //   child: Row(
                                      //     crossAxisAlignment:
                                      //         CrossAxisAlignment.start,
                                      //     children: [
                                      //       Text(
                                      //         "A.",
                                      //         style: TextStyle(
                                      //           color: Colors.white60,
                                      //           // fontFamily: "Baloo",
                                      //           // fontSize: 20,
                                      //         ),
                                      //       ),
                                      //       SizedBox(
                                      //         width: 10,
                                      //       ),
                                      //       Expanded(
                                      //         child: Container(
                                      //           child: Text(
                                      //             "Yes but only after some trial runs, just to be sure that it is safe to ride on ooowieeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee.",
                                      //             style: TextStyle(
                                      //               color: Colors.white,
                                      //               // fontFamily: "Baloo",
                                      //               // fontSize: 16,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),

                                      Option(
                                          label: 'A', body: widget.option1text),
                                      Option(
                                          label: 'B', body: widget.option2text),
                                      Option(
                                          label: 'C', body: widget.option3text),
                                      Option(
                                          label: 'D', body: widget.option4text),
                                    ],
                                  )),
                              Container(
                                height: 2,
                                color: Colors.redAccent,
                              ),
                              Container(
                                  height: 250,
                                  child: BarCharts(
                                    count1: widget.option1votes,
                                    count2: widget.option2votes,
                                    count3: widget.option3votes,
                                    count4: widget.option4votes,
                                  )),
                            ],
                          ),
                          CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 500),
                            fadeOutDuration: Duration(milliseconds: 500),
                            imageUrl: widget.imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    )
                  : ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 0, maxHeight: 550),
                      child: CachedNetworkImage(
                        fadeInDuration: Duration(milliseconds: 500),
                        fadeOutDuration: Duration(milliseconds: 500),
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 2,
                    effect: WormEffect(
                      spacing: 8.0,
                      radius: 16.0,
                      dotWidth: 8.0,
                      dotHeight: 8.0,
                      paintStyle: PaintingStyle.fill,
                      strokeWidth: 1.5,
                      dotColor: Colors.white60,
                      activeDotColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BookmarkButton(
                      postId: widget.id,
                      token: widget.token,
                      bookmarked: widget.bookmarked,
                    ),
                    CommentButton(
                      totalCommentsString: widget.totalComments,
                    ),
                    ShareButton(),
                  ],
                ),
              ),

              widget.description != ''
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 15.5,
                          fontFamily: "Baloo",
                          height: 1,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(),

              widget.votable
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxHeight: 300, minHeight: 100),
                            child: Container(
                              // height: 200,
                              decoration: BoxDecoration(
                                  color: kGgreyishBlack,
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  VoteOptions(
                                    optionText: widget.option1text,
                                    currentSelectedLabel: currentLabel == ''
                                        ? optionLabel
                                        : currentLabel,
                                    onSelect: currentLabel == ''
                                        ? changeOption
                                        : () {},
                                    label: 'A',
                                  ),
                                  VoteOptions(
                                    optionText: widget.option2text,
                                    currentSelectedLabel: currentLabel == ''
                                        ? optionLabel
                                        : currentLabel,
                                    onSelect: currentLabel == ''
                                        ? changeOption
                                        : () {},
                                    label: 'B',
                                  ),
                                  VoteOptions(
                                    optionText: widget.option3text,
                                    currentSelectedLabel: currentLabel == ''
                                        ? optionLabel
                                        : currentLabel,
                                    onSelect: currentLabel == ''
                                        ? changeOption
                                        : () {},
                                    label: 'C',
                                  ),
                                  VoteOptions(
                                    optionText: widget.option4text,
                                    currentSelectedLabel: currentLabel == ''
                                        ? optionLabel
                                        : currentLabel,
                                    onSelect: currentLabel == ''
                                        ? changeOption
                                        : () {},
                                    label: 'D',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                              child: Text(
                                currentLabel == ""
                                    ? "VOTE"
                                    : 'VOTED $currentLabel',
                                style: TextStyle(
                                  fontFamily: "Baloo",
                                  color: Colors.white,
                                  letterSpacing: 2,
                                  fontSize: 25,
                                  height: 2.15,
                                ),
                              ),
                              onPressed: () {
                                if (currentLabel != '') {
                                  return;
                                }
                                setState(() {
                                  currentLabel = optionLabel;
                                });
                                voteOnPost(
                                  token: context.read(tokenProvider).state!,
                                  parentPostId: widget.id,
                                  option: currentLabel,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 2,
              ),

              CommentBox(
                parentPostId: widget.id,
                votable: widget.votable,
                optionChoosen: currentLabel,
              ),
              DarkDivider(height: 2),
              SizedBox(
                height: 1,
              ),
              DarkDivider(height: 2),
              CommentSection(
                totalComments: widget.totalComments,
                postId: widget.id,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Option extends StatelessWidget {
  Option({required this.label, required this.body});
  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label.",
            style: TextStyle(
              color: Colors.white60,
              // fontFamily: "Baloo",
              // fontSize: 20,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              child: Text(
                body,
                style: TextStyle(
                  color: Colors.white,
                  // fontFamily: "Baloo",
                  // fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentSection extends StatefulWidget {
  CommentSection({
    required this.totalComments,
    required this.postId,
  });
  final String totalComments;
  final String postId;
  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  static const _pageSize = 10;
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await getComments(
        paginationNumber: pageKey.toString(),
        postId: widget.postId,
        token: context.read(tokenProvider).state!,
      );
      if (response.statusCode == 200) {
        final newItems = json.decode(json.decode(response.body));
        final isLastPage = newItems.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          // final nextPageKey = pageKey + newItems.length;
          _pagingController.appendPage(newItems, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 500, minHeight: 0),
      child: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    "Comments",
                    style: TextStyle(
                      fontFamily: "Baloo",
                      fontSize: 18,
                      height: 0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.fiber_manual_record,
                    size: 8,
                    color: Colors.white60,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.totalComments,
                    style: TextStyle(
                      fontFamily: "Baloo",
                      fontSize: 17,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PagedListView<int, dynamic>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                    firstPageErrorIndicatorBuilder: (_) => ElevatedButton.icon(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: () => _pagingController.refresh(),
                          icon: Icon(Icons.replay),
                          label: Text('Try Again?'),
                        ),
                    itemBuilder: (context, item, index) {
                      final String time =
                          Jiffy(DateTime.parse(item['posted_at']).toLocal())
                              .fromNow();
                      return UserComment(
                        id: item['id'].toString(),
                        time: time.toString(),
                        message: item['message'].toString(),
                        username: item['username'].toString(),
                        replyCount: item['replyCount'].toString(),
                        userProfileImageLink:
                            item['userProfileImageLink'].toString(),
                        optionChoosen: item['optionChoosen'],
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VoteOptions extends StatelessWidget {
  const VoteOptions({
    required this.optionText,
    required this.currentSelectedLabel,
    required this.label,
    required this.onSelect,
  });

  final String optionText;
  final String? currentSelectedLabel;
  final String? label;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        // horizontal: 8.0,
      ),
      child: RadioListTile(
        dense: true,
        contentPadding: const EdgeInsets.all(0),
        title: Text(
          optionText,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        value: label,
        groupValue: currentSelectedLabel,
        onChanged: (dynamic value) {
          onSelect(label);
        },
        activeColor: Colors.redAccent,
      ),
    );
  }
}
