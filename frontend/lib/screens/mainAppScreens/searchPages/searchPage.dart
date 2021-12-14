import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/screens/mainAppScreens/searchPages/searchPage_posts.dart';
import 'package:opinion_frontend/screens/mainAppScreens/searchPages/searchPage_users.dart';
import 'package:opinion_frontend/services/glowRemover.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  List<Tab> _searchTabs = [
    Tab(
      text: "Users",
    ),
    Tab(
      text: "Posts",
    ),
  ];

  List<Widget> _searchpageList = [
    SearchPageUsers(),
    SearchPagePosts(),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _searchpageList.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          // titleSpacing: 0.0,
          backgroundColor: Colors.black,
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white70,
            ),
            width: double.infinity,
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.black87),
              cursorColor: Colors.black87,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black54,
                ),
                hintStyle: TextStyle(fontSize: 18),
                hintText: 'Search',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _controller.clear();
                    context.read(searchTextProvider).state = '';
                    context
                        .read(searchUserPagingControllerProvider)
                        .state
                        .refresh();
                  },
                ),
              ),
              onChanged: (String currentText) {
                context.read(searchTextProvider).state = currentText;
                context
                    .read(searchUserPagingControllerProvider)
                    .state
                    .refresh();
              },
            ),
          ),
          // actions: [
          //   // SizedBox(
          //   //   width: 10,
          //   // ),
          //   // IconButton(
          //   //   icon: Icon(Icons.arrow_back),
          //   //   onPressed: () {},
          //   // ),

          //   SizedBox(
          //     width: 20,
          //   ),
          //   Padding(
          //     padding: const EdgeInsets.all(4.0),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         color: Colors.white70,
          //       ),
          //       width: 350,
          //       child: Theme(
          //         data: Theme.of(context).copyWith(
          //           primaryColor: Colors.black54,
          //         ),
          //         child: TextField(
          //           style: TextStyle(color: Colors.black87),
          //           cursorColor: Colors.black87,
          //           textAlign: TextAlign.start,
          //           decoration: InputDecoration(
          //             prefixIcon: Icon(Icons.search),
          //             hintStyle: TextStyle(fontSize: 18),
          //             hintText: 'Search',
          //             border: InputBorder.none,
          //             suffixIcon: IconButton(
          //               splashColor: Colors.transparent,
          //               icon: Icon(
          //                 Icons.cancel,
          //                 color: Colors.white,
          //               ),
          //               onPressed: () => _controller.clear(),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          //  Spacer(),
          // ],

          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: _searchTabs,
            onTap: (_) {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        body: Column(children: [
          Expanded(
            child: GlowRemover(
              child: TabBarView(
                children: _searchpageList.map((Widget page) => page).toList(),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
