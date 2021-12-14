import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> saveBookmark({
  required String postId,
  required String token,
  required String action,
}) async {
  Future<http.Response> response = http.post(
    Uri.parse(
      '$kUrl/post/bookmarkpost/',
    ),
    headers: {'Authorization': 'Token $token'},
    body: {'postId': postId, 'action': action},
  );
  return response;
}
