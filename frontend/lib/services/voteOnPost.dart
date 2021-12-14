import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> voteOnPost({
  required String token,
  required String parentPostId,
  required String option,
}) async {
  Future<http.Response> response = http.post(
      Uri.parse(
        '$kUrl/post/vote/',
      ),
      body: {
        'parentPostId': parentPostId,
        'option': option,
      },
      headers: {
        'Authorization': 'Token $token'
      });
  return response;
}
