import 'package:flutter/material.dart';

class SearchPagePosts extends StatelessWidget {
  const SearchPagePosts({Key? key}) : super(key: key);
  static const screenName = '/searchpage/posts';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        'Posts',
        style: TextStyle(color: Colors.white),
      )),
    );
  }
}
