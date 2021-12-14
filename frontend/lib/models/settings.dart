import 'package:hive/hive.dart';
part 'settings.g.dart';

@HiveType(typeId: 0)
class Settings {
  @HiveField(0)
  final disableAllNotifBool;
  @HiveField(1)
  final commentNotifBool;
  @HiveField(2)
  final replyNotifBool;
  @HiveField(3)
  final voteNotifBool;
  @HiveField(4)
  final mentionNotifBool;
  @HiveField(5)
  final showOptionsBool;

  Settings({
    this.disableAllNotifBool = false,
    this.commentNotifBool = true,
    this.replyNotifBool = true,
    this.voteNotifBool = true,
    this.mentionNotifBool = true,
    this.showOptionsBool = true,
  });

  Settings copyWith(
          {bool? disableAllNotifBool,
          bool? commentNotifBool,
          bool? replyNotifBool,
          bool? voteNotifBool,
          bool? mentionNotifBool,
          bool? showOptionsBool}) =>
      Settings(
        disableAllNotifBool: disableAllNotifBool ?? this.disableAllNotifBool,
        showOptionsBool: showOptionsBool ?? this.showOptionsBool,
        mentionNotifBool: mentionNotifBool ?? this.mentionNotifBool,
        voteNotifBool: voteNotifBool ?? this.voteNotifBool,
        replyNotifBool: replyNotifBool ?? this.replyNotifBool,
        commentNotifBool: commentNotifBool ?? this.commentNotifBool,
      );
}
