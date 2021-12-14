import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> followUnfollow({
  required String userId,
  required String token,
  required String followOrUnfollow,
}) async {
  Future<http.Response> response = http.post(
    Uri.parse(
      followOrUnfollow == 'follow'
          ? '$kUrl/users/follow/'
          : '$kUrl/users/unfollow/',
    ),
    headers: {'Authorization': 'Token $token'},
    body: {
      'userId': userId,
    },
  );
  return response;
}
