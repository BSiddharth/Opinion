import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jiffy/jiffy.dart';
import 'package:opinion_frontend/components/bookmark.dart';
import 'package:opinion_frontend/components/postPreShowcaseWidget.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/services/getHomePagePosts.dart';
import 'package:opinion_frontend/services/glowRemover.dart';

class HomePage extends StatelessWidget {
  static const screenName = '/homepage';
  final TextStyle listTileTitleStyle = TextStyle(
    fontSize: 15,
    color: Colors.white,
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Bookmarks(),
            Expanded(child: GlowRemover(child: HomePagePosts())),
          ],
        ),
      ),
    );
  }
}

class HomePagePosts extends StatefulWidget {
  const HomePagePosts({Key? key}) : super(key: key);

  @override
  _HomePagePostsState createState() => _HomePagePostsState();
}

class _HomePagePostsState extends State<HomePagePosts> {
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
      final response = await getHomePagePosts(
        paginationNumber: pageKey.toString(),
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
              final time =
                  Jiffy(DateTime.parse(item['posted_at']).toLocal()).fromNow();
              return PostPreShowcaseWidget(
                section: item['section'],
                description: item['description'],
                imageUrl: item['imageUrl'],
                option1text: item['option1text'],
                option1votes: item['option1votes'],
                option2text: item['option2text'],
                option2votes: item['option2votes'],
                option3text: item['option3text'],
                option3votes: item['option3votes'],
                option4text: item['option4text'],
                option4votes: item['option4votes'],
                profilePicUrl: item['userProfileImage'],
                time: time,
                title: item['title'],
                userName: item['username'],
                votable: item['votable'],
                totalComments: item['totalComments'],
                id: item['id'],
                bookmarked: item['bookmarked'],
                optionChoosen: item['optionChoosen'],
              );
            }),
      ),
    );
  }
}
