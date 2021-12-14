import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:opinion_frontend/models/settings.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/services/glowRemover.dart';
import 'package:opinion_frontend/services/logOut.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const screenName = '/settingsPage';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Settings"),
          elevation: 2,
          shadowColor: Colors.white,
          backgroundColor: Colors.black,
        ),
        body: GlowRemover(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Text(
                  "Notification",
                  style: TextStyle(color: Colors.white60),
                ),
              ),
              SettingsPageSwitchTile(
                title: "Disable all notification",
                iconName: Icons.notifications_off,
                boolValue: watch(disableAllNotifBoolProvider).state,
                onTapFunction: () {
                  if (context.read(disableAllNotifBoolProvider).state ==
                      false) {
                    context.read(disableAllNotifBoolProvider).state = true;
                    context.read(commentNotifBoolProvider).state = false;
                    context.read(replyNotifBoolProvider).state = false;
                    context.read(mentionNotifBoolProvider).state = false;
                    context.read(voteNotifBoolProvider).state = false;

                    final box = Hive.box('settings');
                    Settings settings = box.getAt(0) as Settings;
                    box.putAt(
                      0,
                      settings.copyWith(
                        disableAllNotifBool:
                            context.read(disableAllNotifBoolProvider).state,
                        commentNotifBool:
                            context.read(commentNotifBoolProvider).state,
                        replyNotifBool:
                            context.read(replyNotifBoolProvider).state,
                        mentionNotifBool:
                            context.read(mentionNotifBoolProvider).state,
                        voteNotifBool:
                            context.read(voteNotifBoolProvider).state,
                      ),
                    );
                  } else {
                    context.read(disableAllNotifBoolProvider).state = false;
                    final box = Hive.box('settings');
                    Settings settings = box.getAt(0) as Settings;
                    box.putAt(
                        0,
                        settings.copyWith(
                            disableAllNotifBool: context
                                .read(disableAllNotifBoolProvider)
                                .state));
                  }
                },
              ),
              SettingsPageSwitchTile(
                title: "Comment notification",
                iconName: Icons.chat_bubble,
                boolValue: watch(commentNotifBoolProvider).state,
                onTapFunction: () {
                  context.read(commentNotifBoolProvider).state =
                      !context.read(commentNotifBoolProvider).state;
                  context.read(disableAllNotifBoolProvider).state = false;

                  final box = Hive.box('settings');
                  Settings settings = box.getAt(0) as Settings;
                  box.putAt(
                    0,
                    settings.copyWith(
                      disableAllNotifBool:
                          context.read(disableAllNotifBoolProvider).state,
                      commentNotifBool:
                          context.read(commentNotifBoolProvider).state,
                    ),
                  );
                },
              ),
              SettingsPageSwitchTile(
                title: "Reply notification",
                iconName: Icons.reply,
                boolValue: watch(replyNotifBoolProvider).state,
                onTapFunction: () {
                  context.read(replyNotifBoolProvider).state =
                      !context.read(replyNotifBoolProvider).state;
                  context.read(disableAllNotifBoolProvider).state = false;

                  final box = Hive.box('settings');
                  Settings settings = box.getAt(0) as Settings;
                  box.putAt(
                    0,
                    settings.copyWith(
                      disableAllNotifBool:
                          context.read(disableAllNotifBoolProvider).state,
                      replyNotifBool:
                          context.read(replyNotifBoolProvider).state,
                    ),
                  );
                },
              ),
              SettingsPageSwitchTile(
                title: "Mention notification",
                iconName: Icons.alternate_email,
                boolValue: watch(mentionNotifBoolProvider).state,
                onTapFunction: () {
                  context.read(mentionNotifBoolProvider).state =
                      !context.read(mentionNotifBoolProvider).state;
                  context.read(disableAllNotifBoolProvider).state = false;

                  final box = Hive.box('settings');
                  Settings settings = box.getAt(0) as Settings;
                  box.putAt(
                    0,
                    settings.copyWith(
                      disableAllNotifBool:
                          context.read(disableAllNotifBoolProvider).state,
                      mentionNotifBool:
                          context.read(mentionNotifBoolProvider).state,
                    ),
                  );
                },
              ),
              SettingsPageSwitchTile(
                title: "Vote notification",
                iconName: Icons.how_to_vote,
                boolValue: watch(voteNotifBoolProvider).state,
                onTapFunction: () {
                  context.read(voteNotifBoolProvider).state =
                      !context.read(voteNotifBoolProvider).state;
                  context.read(disableAllNotifBoolProvider).state = false;

                  final box = Hive.box('settings');
                  Settings settings = box.getAt(0) as Settings;
                  box.putAt(
                    0,
                    settings.copyWith(
                      disableAllNotifBool:
                          context.read(disableAllNotifBoolProvider).state,
                      voteNotifBool: context.read(voteNotifBoolProvider).state,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Text(
                  "Advanced",
                  style: TextStyle(color: Colors.white60),
                ),
              ),
              SettingsPageSwitchTile(
                title: "Show options by default",
                boolValue: watch(showOptionsBoolProvider).state,
                iconName: Icons.view_headline,
                onTapFunction: () {
                  context.read(showOptionsBoolProvider).state =
                      !context.read(showOptionsBoolProvider).state;

                  final box = Hive.box('settings');
                  Settings settings = box.getAt(0) as Settings;
                  box.putAt(
                    0,
                    settings.copyWith(
                      showOptionsBool:
                          context.read(showOptionsBoolProvider).state,
                    ),
                  );
                },
              ),
              SettingPageTile(
                iconName: Icons.info,
                title: "App version",
                data: "1.02.56",
              ),
              SettingPageTile(
                iconName: Icons.feedback,
                title: "Send feedback",
              ),
              SettingPageTile(
                iconName: Icons.book,
                title: "Licenses",
              ),
              SettingPageTile(
                iconName: Icons.delete,
                title: "Clear all cache",
                color: Colors.redAccent,
                data: "69 MB",
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Text(
                  "Account",
                  style: TextStyle(color: Colors.white60),
                ),
              ),
              SettingPageTile(
                iconName: Icons.edit,
                title: "Edit Profile",
              ),
              SettingPageTile(
                iconName: Icons.exit_to_app,
                title: "Log out",
                onTap: () async {
                  await logOut(context);

                  Navigator.pop(context);
                },
              ),
              SettingPageTile(
                iconName: Icons.cancel,
                color: Colors.redAccent,
                title: "Delete my account",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsPageSwitchTile extends StatelessWidget {
  const SettingsPageSwitchTile({
    required this.boolValue,
    required this.onTapFunction,
    required this.title,
    required this.iconName,
  });

  final bool? boolValue;
  final Function onTapFunction;
  final String title;
  final IconData iconName;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      height: 55,
      child: TextButton(
        style:
            TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 15)),
        onPressed: onTapFunction as void Function()?,
        child: Row(
          children: [
            Icon(
              iconName,
              color: Colors.white60,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
            ),
            Spacer(),
            AbsorbPointer(
              child: Switch(
                value: boolValue!,
                onChanged: (value) {
                  print(value);
                },
                activeColor: Colors.redAccent,
                inactiveTrackColor: Colors.white60,
                inactiveThumbColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingPageTile extends StatelessWidget {
  const SettingPageTile({
    required this.iconName,
    required this.title,
    this.color,
    this.data,
    this.onTap,
  });
  final IconData iconName;
  final String title;
  final String? data;
  final Color? color;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      height: 55,
      child: TextButton(
        style:
            TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 15)),
        onPressed: onTap == null ? () {} : onTap as void Function(),
        child: Row(
          children: [
            Icon(
              iconName,
              color: color ?? Colors.white60,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
            ),
            Spacer(),
            Text(
              data ?? "",
              style: TextStyle(
                color: Colors.white60,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
