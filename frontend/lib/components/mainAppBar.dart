import 'package:flutter/material.dart';
// import 'package:opinion/components/show_profile_picture.dart';
// import 'package:opinion/screens/main_page_screens/add_post_page.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "OPINION",
        style: TextStyle(
          fontFamily: "Baloo",
          fontSize: 30,
          fontWeight: FontWeight.normal,
        ),
      ),
      centerTitle: true,
      // actions: [

      //   IconButton(
      //     icon: Icon(
      //       Icons.add,
      //       // Icons.add_circle_outline_rounded,
      //     ),
      //     // icon: Icon(Icons.chat_bubble),
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => AddPostPage()),
      //       );
      //     },
      //   ),
      // ],
      backgroundColor: Colors.black,
    );
  }
}
