import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jiffy/jiffy.dart';
import 'package:opinion_frontend/components/darkDivider.dart';
import 'package:opinion_frontend/components/optionChoosen.dart';
import 'package:opinion_frontend/components/showProfilePicture.dart';
import 'package:opinion_frontend/components/userReply.dart';
import 'package:opinion_frontend/services/createReply.dart';
import 'package:opinion_frontend/services/getReplies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opinion_frontend/providers.dart';

class CommentsDetailedPage extends StatefulWidget {
  static const screenName = '/CommentsDetailedPage';
  CommentsDetailedPage({
    required this.shouldOpenkeyboard,
    required this.id,
    required this.replyCount,
    required this.time,
    required this.message,
    required this.userProfileImageLink,
    required this.username,
    required this.optionChoosen,
  });
  final bool shouldOpenkeyboard;
  final String id;
  final String replyCount;
  final String time;
  final String message;
  final String userProfileImageLink;
  final String username;
  final String optionChoosen;

  @override
  _CommentsDetailedPageState createState() => _CommentsDetailedPageState();
}

class _CommentsDetailedPageState extends State<CommentsDetailedPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Replies'),
          titleSpacing: 0,
        ),
        body: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Comment",
                    style: TextStyle(
                      fontFamily: "Baloo",
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 8.0, 10.0, 3.0),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShowProfilePicture(
                            dimension: 40,
                            url: widget.userProfileImageLink,
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
                                    widget.username,
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
                                  widget.optionChoosen == ""
                                      ? Container()
                                      : Icon(
                                          Icons.fiber_manual_record,
                                          size: 5,
                                          color: Colors.white60,
                                        ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  widget.optionChoosen == ""
                                      ? Container()
                                      : OptionChoosen(
                                          optionChoosen: widget.optionChoosen,
                                        )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.time,
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
                        widget.message,
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
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    children: [
                      Text(
                        "Replies",
                        style: TextStyle(
                          fontFamily: "Baloo",
                          fontSize: 18,
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
                      Text(
                        widget.replyCount,
                        style: TextStyle(
                          fontFamily: "Baloo",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // ReplySection(commentId: widget.id)
                // UserReply(),
                // UserReply(),
                // UserReply(),
              ],
            ),
            Expanded(child: ReplySection(commentId: widget.id)),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      autofocus: widget.shouldOpenkeyboard,
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Your comment here",
                        isDense: true,
                        filled: true,
                        fillColor: Color(0xffACACAC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: Icon(Icons.send),
                        color: Colors.white,
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          final String message = _controller.text;
                          _controller.text = '';
                          createReply(
                              token: context.read(tokenProvider).state!,
                              message: message,
                              parentCommentId: widget.id);
                        },
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Color(0xFFe0f2f1),
                        color: Colors.redAccent,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReplySection extends StatefulWidget {
  ReplySection({
    required this.commentId,
  });

  final String commentId;

  @override
  _ReplySectionState createState() => _ReplySectionState();
}

class _ReplySectionState extends State<ReplySection> {
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
      final response = await getReplies(
        paginationNumber: pageKey.toString(),
        commentId: widget.commentId,
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
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, dynamic>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<dynamic>(
            firstPageErrorIndicatorBuilder: (_) => ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                  onPressed: () => _pagingController.refresh(),
                  icon: Icon(Icons.replay),
                  label: Text('Try Again?'),
                ),
            itemBuilder: (context, item, index) {
              final String time =
                  Jiffy(DateTime.parse(item['posted_at']).toLocal()).fromNow();
              return UserReply(
                time: time.toString(),
                message: item['message'].toString(),
                username: item['username'].toString(),
                userProfileImageLink: item['userProfileImageLink'].toString(),
              );
            }),
      ),
    );
  }
}
