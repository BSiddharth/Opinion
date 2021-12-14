import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:opinion_frontend/services/saveBookmark.dart';

// class IconWithName extends StatelessWidget {
//   IconWithName(
//       {required this.icon, required this.ontapfunction, required this.name});
//   final double iconTextSize = 14;
//   final double iconSize = 23;
//   final IconData icon;
//   final String name;
//   final Function ontapfunction;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         ontapfunction();
//       },
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             // color: Colors.grey[700],
//             color: Colors.white,

//             size: iconSize,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           Text(
//             name,
//             style: TextStyle(
//               // color: Colors.grey[700],
//               color: Colors.white,

//               fontSize: iconTextSize,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class BookmarkButton extends StatefulWidget {
  BookmarkButton(
      {required this.postId, required this.token, required this.bookmarked});
  final String postId;
  final String token;
  final bool bookmarked;

  @override
  _BookmarkButtonState createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool isBookmarked = false;

  @override
  void initState() {
    isBookmarked = widget.bookmarked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          // padding: const EdgeInsets.all(0),
        ),
        onPressed: () async {
          final Response response = await saveBookmark(
              postId: widget.postId,
              token: widget.token,
              action: isBookmarked ? 'remove' : 'add');
          if (response.statusCode == 200) {
            setState(() {
              isBookmarked = !isBookmarked;
            });
          }
        },
        icon: isBookmarked
            ? Icon(
                Icons.bookmark,
                size: 23,
              )
            : Icon(
                Icons.bookmark_border,
                size: 23,
              ),
        // icon: Icon(Icons.bookmark),
        label: Text(
          "Bookmark",
          style: TextStyle(fontSize: 14),
        ));
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          // padding: const EdgeInsets.all(0),
        ),
        onPressed: () {
          print('hi');
        },
        icon: Icon(
          Icons.share_outlined,
          size: 23,
        ),
        label: Text(
          "Share",
          style: TextStyle(fontSize: 14),
        ));
  }
}

class CommentButton extends StatelessWidget {
  CommentButton({required this.totalCommentsString});
  final String totalCommentsString;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,

            // padding: const EdgeInsets.all(0),
          ),
          onPressed: () {},
          icon: Icon(
            Icons.chat_bubble_outline,
            size: 23,
          ),
          label: Text(
            totalCommentsString,
            style: TextStyle(fontSize: 14),
          )),
    );
  }
}
