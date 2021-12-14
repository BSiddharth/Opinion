import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> getPosts({
  required String username,
  required String paginationNumber,
  required String token,
}) async {
  Future<http.Response> response = http.post(
    Uri.parse(
      '$kUrl/post/getposts/',
    ),
    headers: {'Authorization': 'Token $token'},
    body: {
      'username': username,
      'paginationNumber': paginationNumber,
    },
  );
  return response;
}
