import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:opinion_frontend/components/miniUserTile.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/services/searchUsers.dart';

class SearchPageUsers extends StatefulWidget {
  const SearchPageUsers({Key? key}) : super(key: key);
  static const screenName = '/searchpage/users';

  @override
  _SearchPageUsersState createState() => _SearchPageUsersState();
}

class _SearchPageUsersState extends State<SearchPageUsers> {
  static const _pageSize = 10;
  // final PagingController<int, dynamic> _pagingController =
  //     PagingController(firstPageKey: 1);

  @override
  void initState() {
    context
        .read(searchUserPagingControllerProvider)
        .state
        .addPageRequestListener((pageKey) {
      // _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await searchUsers(
        paginationNumber: pageKey.toString(),
        token: context.read(tokenProvider).state!,
        startsWith: context.read(searchTextProvider).state,
      );
      if (response.statusCode == 200) {
        final newItems = json.decode(json.decode(response.body));
        final isLastPage = newItems.length < _pageSize;
        if (isLastPage) {
          context
              .read(searchUserPagingControllerProvider)
              .state
              .appendLastPage(newItems);
          // _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          // final nextPageKey = pageKey + newItems.length;
          context
              .read(searchUserPagingControllerProvider)
              .state
              .appendPage(newItems, nextPageKey);
          // _pagingController.appendPage(newItems, nextPageKey);
        }
      }
    } catch (error) {
      context.read(searchUserPagingControllerProvider).state.error = error;
      // _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    context.read(searchUserPagingControllerProvider).state.dispose();
    context.read(searchTextProvider).state = '';
    // _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => context.read(searchUserPagingControllerProvider).state.refresh(),
        // () => _pagingController.refresh(),
      ),
      child: Container(
        color: Colors.black,
        child: PagedListView<int, dynamic>(
          pagingController:
              context.read(searchUserPagingControllerProvider).state,
          // pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
              firstPageErrorIndicatorBuilder: (_) => ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    onPressed: () => context
                        .read(searchUserPagingControllerProvider)
                        .state
                        .refresh(),
                    // onPressed: () => _pagingController.refresh(),
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
      ),
    );
  }
}
