import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> getComments({
  required String paginationNumber,
  required String token,
  required String postId,
}) async {
  Future<http.Response> response = http.post(
    Uri.parse(
      '$kUrl/post/getComments/',
    ),
    headers: {'Authorization': 'Token $token'},
    body: {
      'paginationNumber': paginationNumber,
      'postId': postId,
    },
  );
  return response;
}
