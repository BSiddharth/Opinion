import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:opinion_frontend/models/userDetails.dart';

import 'components/mainAppBar.dart';

enum AuthenticationStatus { authenticated, notAuthenticated, loading }

final authenticationStatusProvider =
    StateProvider<AuthenticationStatus>((ref) => AuthenticationStatus.loading);

final tokenProvider = StateProvider<String?>((ref) => null);

final emailProvider = StateProvider<String>((ref) => '');

final disableAllNotifBoolProvider = StateProvider<bool>((ref) => false);
final commentNotifBoolProvider = StateProvider<bool>((ref) => true);
final replyNotifBoolProvider = StateProvider<bool>((ref) => true);
final voteNotifBoolProvider = StateProvider<bool>((ref) => true);
final mentionNotifBoolProvider = StateProvider<bool>((ref) => true);
final showOptionsBoolProvider = StateProvider<bool>((ref) => true);

final sectionProvider = StateProvider.autoDispose<String>((ref) => 'General');
final sectionImageProvider =
    StateProvider.autoDispose<String>((ref) => 'assets/images/general.jpg');

final currentIndexProvider = StateProvider<int>((ref) => 0);

final currentAppBarProvider =
    StateProvider.autoDispose<PreferredSizeWidget?>((ref) => MainAppBar());

final currentUserDetailsProvider =
    StateProvider<UserDetails>((ref) => UserDetails());
final searchTextProvider = StateProvider<String>((ref) => '');

final searchUserPagingControllerProvider =
    StateProvider<PagingController<int, dynamic>>(
        (ref) => PagingController(firstPageKey: 1));

// class Token extends StateNotifier<String> {
//   Token() : super('');

//   void setToken(token) {
//     state = token;
//   }
// }

// final tokenProvider = StateNotifierProvider((ref) => Token());
