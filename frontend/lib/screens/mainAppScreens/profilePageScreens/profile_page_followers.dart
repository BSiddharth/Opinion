import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:opinion_frontend/components/miniUserTile.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/services/getFollowers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePageFollowers extends StatefulWidget {
  @override
  _ProfilePageFollowersState createState() => _ProfilePageFollowersState();
}

class _ProfilePageFollowersState extends State<ProfilePageFollowers> {
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
      final response = await getFollowers(
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
              return MiniUserTile(
                userProfilePicLink: item['profilePicLink'],
                following: item['following'],
                username: item['username'],
                fullname: item['fullname'],
                id: item['id'],
                // about: item['about'],
                // title: item['description'],
              );
            }),
      ),
    );
  }
}
