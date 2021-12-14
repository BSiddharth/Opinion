import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> createReply({
  required String token,
  required String message,
  required String parentCommentId,
}) async {
  Future<http.Response> response = http.post(
      Uri.parse(
        '$kUrl/post/createReply/',
      ),
      body: {
        'message': message,
        'parentCommentId': parentCommentId,
      },
      headers: {
        'Authorization': 'Token $token'
      });
  return response;
}
