import 'package:hive/hive.dart';
part 'userDetails.g.dart';

@HiveType(typeId: 1)
class UserDetails {
  @HiveField(0)
  final String firstname;
  @HiveField(1)
  final String lastname;
  @HiveField(2)
  final String username;
  @HiveField(3)
  final String about;
  @HiveField(4)
  final String userprofileimagelink;
  @HiveField(5)
  final String title;

  UserDetails({
    this.firstname = '',
    this.lastname = '',
    this.username = '',
    this.about = '',
    this.userprofileimagelink = '',
    this.title = '',
  });

  UserDetails copyWith(
          {String? firstname,
          String? lastname,
          String? username,
          String? about,
          String? userprofileimagelink,
          String? title}) =>
      UserDetails(
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        userprofileimagelink: userprofileimagelink ?? this.userprofileimagelink,
        about: about ?? this.about,
        username: username ?? this.username,
        title: title ?? this.title,
      );
}
