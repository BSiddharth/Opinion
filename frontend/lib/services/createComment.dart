import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> createComment({
  required String token,
  required String message,
  required String parentPostId,
}) async {
  Future<http.Response> response = http.post(
      Uri.parse(
        '$kUrl/post/createComment/',
      ),
      body: {
        'message': message,
        'parentPostId': parentPostId,
      },
      headers: {
        'Authorization': 'Token $token'
      });
  return response;
}
