import 'package:flutter/material.dart';
import 'package:opinion_frontend/components/optionChoosen.dart';
import 'package:opinion_frontend/components/showProfilePicture.dart';
import 'package:opinion_frontend/services/createComment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opinion_frontend/providers.dart';

import 'darkDivider.dart';

class CommentBox extends StatefulWidget {
  CommentBox({
    required this.parentPostId,
    required this.optionChoosen,
    required this.votable,
  });
  final String parentPostId;
  final String optionChoosen;
  final bool votable;
  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DarkDivider(height: 10),
        Padding(
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 10.0, 0.0),
          child: Text(
            "Comment Box",
            style: TextStyle(
              fontFamily: "Baloo",
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(8.0, 0.0, 10.0, 0.0),
          child: Consumer(builder: (context, ref, child) {
            final userDetails = context.read(currentUserDetailsProvider).state;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShowProfilePicture(
                  dimension: 40,
                  url: userDetails.userprofileimagelink,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  userDetails.username,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // fontFamily: "Baloo",
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                widget.optionChoosen != '' && widget.votable
                    ? Row(
                        children: [
                          Icon(
                            Icons.fiber_manual_record,
                            size: 5,
                            color: Colors.white60,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          OptionChoosen(
                            optionChoosen: widget.optionChoosen,
                          ),
                        ],
                      )
                    : Container(),
                // Expanded(
                //   child: OptionChoosen(),
                // )
              ],
            );
          }),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 2, 8),
                child: TextFormField(
                  controller: _controller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Comment can't be empty";
                    }
                  },
                  // textAlignVertical: TextAlignVertical.bottom,
                  cursorColor: Colors.white60,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),

                  decoration: InputDecoration(
                    isDense: true,
                    fillColor: Colors.grey[900],
                    filled: true,
                    contentPadding: const EdgeInsets.all(5),
                    hintText: "Type your comment here",
                    hintStyle: TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  maxLines: 6,
                  minLines: 5,
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
                      final String message = _controller.text.trim();
                      setState(() {
                        _controller.text = '';
                      });
                      createComment(
                          token: context.read(tokenProvider).state!,
                          message: message,
                          parentPostId: widget.parentPostId);
                    },
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // color: Color(0xFFe0f2f1),
                    color: Colors.redAccent,
                  ),
                )),
          ],
        ),
      ],
    );
  }
}
